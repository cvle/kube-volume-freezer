package main

import (
	"fmt"

	"github.com/wikiwi/kube-volume-freezer/pkg/client"
	"github.com/wikiwi/kube-volume-freezer/pkg/util/validation"
)

type listCommand struct {
	Address   string `long:"address" default:"http://localhost:8080" env:"KVF_ADDRESS" description:"Address of kvf-master"`
	Namespace string `long:"namespace" default:"default" env:"KVF_NAMESPACE" description:"Namespace of Pod"`
	Token     string `short:"t" long:"token" env:"KVF_TOKEN" description:"Use given token for api user authentication"`
}

func (cmd *listCommand) Execute(args []string) error {
	if len(args) < 1 {
		return fmt.Errorf("Error: Please specify Pod and Volume.")
	}
	if len(args) > 1 {
		return fmt.Errorf("Error: Unexpected argument %s", args[1:])
	}

	podName := args[0]

	if issues := validation.ValidateQualitfiedName(cmd.Namespace); len(issues) > 0 {
		return fmt.Errorf("Error: Invalid Namespace %s", issues)
	}
	if issues := validation.ValidateQualitfiedName(podName); len(issues) > 0 {
		return fmt.Errorf("Error: Invalid Pod Name %s", issues)
	}

	client, err := client.New(cmd.Address, cmd.Token, nil)
	if err != nil {
		return err
	}
	ls, err := client.Volumes().List(cmd.Namespace, podName)
	for _, item := range ls.Items {
		fmt.Println(item)
	}
	return err
}

func init() {
	parser.AddCommand("list",
		"List Pod Volumes",
		"List Pod Volumes",
		new(listCommand))
}
