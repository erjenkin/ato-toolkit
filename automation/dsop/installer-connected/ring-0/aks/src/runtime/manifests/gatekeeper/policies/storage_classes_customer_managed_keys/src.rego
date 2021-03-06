package com.microsoft.c12.ecnryptionatrest


pvcName := input.review.name
storageclassInPvc := input.review.object.spec.storageClassName


violation[{"msg": msg, "details": { "storageClass" : storageClass }}] {		
	
	storageclassDefinition := data.inventory.cluster["storage.k8s.io/v1"].StorageClass[storageclassInPvc]	
	provisioner := storageclassDefinition.provisioner

	provisioner == "kubernetes.io/azure-disk"	
	not storageclassDefinition.parameters.diskEncryptionSetID
	
	storageClass := storageclassInPvc
	msg:= sprintf("PermanentVolumeClaim %s has uses storage class %s, which does not use Customer Managed Keys", [pvcName, storageClass])
}

violation[{"msg": msg, "details": { "storageClass" : storageClass }}] {		
	
	storageclassDefinition := data.inventory.cluster["storage.k8s.io/v1"].StorageClass[storageclassInPvc]	
	provisioner := storageclassDefinition.provisioner

	not provisioner == "kubernetes.io/azure-disk"
	
	storageClass := storageclassInPvc
	msg:= sprintf("PermanentVolumeClaim %s has uses storage class %s, which cannot use Customer Managed Keys", [pvcName, storageClass])
}


violation[{"msg": msg, "details": { "storageClass" : storageClass }}] {		

	not storageclassInPvc
	storageClass := "nil"
	msg:= sprintf("PermanentVolumeClaim %s does not define storage class", [pvcName])
}

