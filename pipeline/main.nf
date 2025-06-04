#!/usr/bin/env nextflow
// hash:sha256:57ffa15c524fcf442338de073d259612932d64a35f8705c6e351672599daef88

// capsule - Job Dispatch Ecephys
process capsule_job_dispatch_ecephys_1 {
	tag 'capsule-6237826'
	container "$REGISTRY_HOST/published/d75d79c4-8f21-4d17-83ec-13b2a43dcaa0:v4"

	cpus 4
	memory '30 GB'

	input:
	path 'capsule/data/'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=d75d79c4-8f21-4d17-83ec-13b2a43dcaa0
	export CO_CPUS=4
	export CO_MEMORY=32212254720

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 --branch v4.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6237826.git" capsule-repo
	else
		git clone --branch v4.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-6237826.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_job_dispatch_ecephys_1_args}

	echo "[${task.tag}] completed!"
	"""
}

params.ecephys_722209_2024_05_07_12_06_27_url = 's3://aind-private-data-prod-o5171v/ecephys_722209_2024-05-07_12-06-27'

workflow {
	// input data
	ecephys_722209_2024_05_07_12_06_27_to_job_dispatch_ecephys_1 = Channel.fromPath(params.ecephys_722209_2024_05_07_12_06_27_url + "/*", type: 'any')

	// run processes
	capsule_job_dispatch_ecephys_1(ecephys_722209_2024_05_07_12_06_27_to_job_dispatch_ecephys_1)
}
