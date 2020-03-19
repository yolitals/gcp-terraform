package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestGCPModule(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: ".",
		Vars: map[string]interface{}{
		},
	}
	defer func() {
		terraform.Destroy(t, terraformOptions)
	}() 
	terraform.Init(t, terraformOptions)
	terraform.Apply(t, terraformOptions)
}
