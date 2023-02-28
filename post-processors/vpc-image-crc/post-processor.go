//go:generate packer-sdc struct-markdown
//go:generate packer-sdc mapstructure-to-hcl2 -type Config

package ibmvpcimagecrc

import (
	"context"
	"fmt"
	"packer-plugin-ibmcloud/builder/ibmcloud/vpc"

	"github.com/IBM/vpc-go-sdk/vpcv1"
	"github.com/hashicorp/hcl/v2/hcldec"
	"github.com/hashicorp/packer-plugin-sdk/common"
	"github.com/hashicorp/packer-plugin-sdk/multistep"
	packersdk "github.com/hashicorp/packer-plugin-sdk/packer"
	"github.com/hashicorp/packer-plugin-sdk/template/config"
	"github.com/hashicorp/packer-plugin-sdk/template/interpolate"
	"google.golang.org/grpc/balancer/grpclb/state"
)

type Config struct {
	common.PackerConfig `mapstructure:",squash"`

	IBMApiKey        string `mapstructure:"api_key"`
	Region           string `mapstructure:"region"`
	sourceImageCRN   string `maptstructure:"source_image_crn"`
	ImageName        string `mapstructure:"image_name"`
	encryptionKeyCRN string `maptstructure:"encryption_key_crn"`

	ctx interpolate.Context
}

// BuilderId =

// packersdk.PostProcessor
type PostProcessor struct {
	config Config
	runner multistep.Runner
}

// func (p *PostProcessor) ConfigSpec() hcldec.ObjectSpec { return p.config.FlatMapstructure().HCL2Spec() }

func (p *PostProcessor) ConfigSpec() hcldec.ObjectSpec {
	return p.config.FlatMapstructure().HCL2Spec()
}

func (p *PostProcessor) Configure(raws ...interface{}) error {
	// BuilderId :=
	err := config.Decode(&p.config, &config.DecodeOpts{
		PluginType:         "ibmcloud.vpc.builder",
		Interpolate:        true,
		InterpolateContext: &p.config.ctx,
	}, raws...)
	if err != nil {
		return err
	}

	errs := new(packersdk.MultiError)

	if p.config.IBMApiKey == "" {
		errs = packersdk.MultiErrorAppend(errs, fmt.Errorf("IBM API Key must be provided.."))
	}
	if p.config.sourceImageCRN == "" {
		errs = packersdk.MultiErrorAppend(errs, fmt.Errorf("Source Image CRN must be provided."))
	}
	if p.config.encryptionKeyCRN == "" {
		errs = packersdk.MultiErrorAppend(errs, fmt.Errorf("Encryption Key CRN is not provided."))
	}
	if p.config.ImageName == "" {
		errs = packersdk.MultiErrorAppend(fmt.Errorf("Export Image name is not provided, using default"))
		p.config.ImageName = "ibm-packer-" + p.config.Region + "-exported-image"
	}
	return nil
}

// Work in progress. ..
func (p *PostProcessor) PostProcess(ctx context.Context, ui packersdk.Ui, artifact packersdk.Artifact) (packersdk.Artifact, bool, bool, error) {
	ui.Say(fmt.Sprintf("post-processor mock: %s", p.config.MockOption))
	var vpcService *vpcv1.VpcV1
	if state.Get("vpcService") != nil {
		vpcService = state.Get("vpcService").(*vpcv1.VpcV1)
	}

	switch artifact.BuilderId() {
	// TODO: uncomment when Packer core stops importing this plugin.
	case vpc.BuilderId, "packer.post-processor.artifice":
		break
	default:
		err := fmt.Errorf(
			"Unknown artifact type: %s\nCan only export from IBM Cloud Packer plugin.",
			artifact.BuilderId())
		return nil, false, false, err
	}

	// IBMApiKey := artifact.State("")

	// Get the validation done and map it to the SDK.
	// SourceImage
	config.ImageName = validName.ReplaceAllString(config.ImageName, "")
	options := &vpcv1.CreateImageOptions{}

	options.EncryptionKey // not needed.
	imagePrototype := &vpcv1.ImagePrototypeImageBySourceImage{
		Name: &config.ImageName,
		SourceImage: &vpcv1.ImageIdentityByCRN{
			CRN: &sourceImageCRN,
		},
	}
	// if image is of type qcow2 need the encryption key CRN

	//if needed
	if config.ResourceGroupID != "" {
		imagePrototype.ResourceGroup = &vpcv1.ResourceGroupIdentityByID{
			ID: &config.ResourceGroupID,
		}
	}

	// stepCreateVPCServiceInstance.
	// separate vpc_instance needs to be used, basically all the steps must be reformed here.
	options.SetImagePrototype(imagePrototype)
	imageData, _, err := vpcService.CreateImage(options)

	return source, true, true, nil
}

// func () test()
