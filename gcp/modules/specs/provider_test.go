package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"time"
)

func TestGCPModule(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../gcp",
		Vars: map[string]interface{}{
		},
		VarFiles: []string{"../specs/specs.tfvars"},
	}

	defer func() {
		time.Sleep(3 * time.Minute)
		terraform.Destroy(t, terraformOptions)
	}() 
	terraform.Init(t, terraformOptions)
	terraform.Apply(t, terraformOptions)
}
