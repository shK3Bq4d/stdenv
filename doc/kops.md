
https://github.com/kubernetes/kops

https://github.com/kubernetes/kops/blob/master/docs/apireference/build/documents/_generated_instancegroup_v1alpha2_kops_concept.md

curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
#sudo mv kops-linux-amd64 /usr/local/bin/kops
mv kops-linux-amd64 ~/bin/kops

kops get ig -o json | jq -r '.[]| .metadata.name + ": " + .spec.machineType'
