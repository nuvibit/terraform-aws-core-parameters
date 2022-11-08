package test

import (
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestCoreParameters(t *testing.T) {
	// retryable errors in terraform testing.
	t.Log("Starting module test")


	// Create IAM Roles
	terraformCoreParameterRoles := &terraform.Options{
		TerraformDir: "../examples/complete",
		NoColor:      false,
		Lock:         true,
		Targets: 	  []string {
			"module.core_parameter_roles",
		},
	}
	defer terraform.Destroy(t, terraformCoreParameterRoles)
	terraform.InitAndApply(t, terraformCoreParameterRoles)

	// Write Parameters
	terraformCoreParametersWriter := &terraform.Options{
		TerraformDir: "../examples/complete",
		NoColor:      false,
		Lock:         true,
		Targets: 	  []string {
			"local.core_org_mgmt_parameters",
			"module.core_parameter_writer1", 
			"local.core_core_security_parameters",
			"module.core_parameter_writer2",
		},
	}
	defer terraform.Destroy(t, terraformCoreParametersWriter)
	terraform.InitAndApply(t, terraformCoreParametersWriter)

	// Read Parameters
	terraformCoreParametersReader := &terraform.Options{
		TerraformDir: "../examples/complete",
		NoColor:      false,
		Lock:         true,
	}
	defer terraform.Destroy(t, terraformCoreParametersReader)
	terraform.InitAndApply(t, terraformCoreParametersReader)
	t.Log(terraform.OutputAll(t, terraformCoreParametersReader))
	reader_validation := terraform.Output(t, terraformCoreParametersReader, "core_parameter_reader_validation")
	t.Log(reader_validation)
	
	if strings.Contains(reader_validation, "true") {
		t.Log("PASSED: ParameterStore tests passed")
	} else {
		t.Errorf("FAILED: ParameterStore tests failed")
	}
}