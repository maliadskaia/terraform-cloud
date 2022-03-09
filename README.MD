workspaces are only for testing! (small dev testing)

workspaces commands:

terraform workspace show     // now we're in default
terraform workspace list
terraform workspace new      // creates new one and automatically switches into it
terraform workspace select   // to move to other existing
terraform workspace delete



// if there are conflicts while creating in new workspaces - better to add variables in sg/ami/... with for example workspace name
