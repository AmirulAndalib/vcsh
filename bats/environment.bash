setup() {
	VCSH="$BATS_TEST_DIRNAME/../vcsh"
	export LC_ALL=C

	# Test repository.  For faster tests, you can create a local mirror and
	# use that instead.
	: ${TESTREPO:='https://github.com/djpohly/vcsh_testrepo.git'}
	: ${TESTREPONAME:='vcsh_testrepo'}
	TESTM1=master
	TESTM2=master2
	TESTBR1=branch1
	TESTBR2=branch2
	TESTBRX=conflict

	BATS_TESTDIR=$(mktemp -d -p "$BATS_TMPDIR")
	export HOME=$BATS_TESTDIR
	export XDG_CONFIG_HOME=$HOME/.config
	cd
}

teardown() {
	cd /
	rm -rf "$BATS_TESTDIR"
}