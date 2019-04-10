#!/bin/bash
# elma-cli v0.4
# Made by Dokter Waldijk
# Search ELMA in the terminal.
# By running this script you agree to the license terms.
# Config ----------------------------------------------------------------------------
ELMANAM="elma-cli"
ELMAVER="0.4"
ELMAQUR="$@"
# -----------------------------------------------------------------------------------
ELMAQUR=$(echo "$ELMAQUR" | sed -r 's/ /%20/g')
ELMAAPI=$(curl -s https://hotell.difi.no/api/json/difi/elma/participants?query=$ELMAQUR | sed -r 's/Ja/Yes/g' | sed -r 's/Nei/No/g')
ELMATST=$(echo "$ELMAAPI" | jq -r '.entries[].name')
ELMALIN=$(echo "$ELMATST" | wc -l)
ELMACNT="0"
if [[ -n $ELMAQUR ]] && [[ -n "$ELMATST" ]]; then
    until [[ "$ELMACNT" = "$ELMALIN" ]]; do
        if [[ "$ELMACNT" -ge "1" ]]; then
            echo ""
        fi
        echo -n "   Name: "
        echo -n "$ELMAAPI" | jq -r ".entries[$ELMACNT].name"
        echo -n "    ICD: "
        echo -n "$ELMAAPI" | jq -r ".entries[$ELMACNT].Icd"
        echo -n "   Org#: "
        echo -n "$ELMAAPI" | jq -r ".entries[$ELMACNT].identifier"
        echo -n "EHF 2.0: "
        echo -n "$ELMAAPI" | jq -r ".entries[$ELMACNT].EHF_INVOICE_CREDITNOTE_2_0"
        echo -n "EHF 3.0: "
        echo -n "$ELMAAPI" | jq -r ".entries[$ELMACNT].PEPPOLBIS_3_0_BILLING_01_UBL"
        ELMACNT=$(expr $ELMACNT + 1)
    done
elif [[ -n $ELMAQUR ]] && [[ -z "$ELMATST" ]]; then
    ELMAQUR=$(echo "$ELMAQUR" | sed -r 's/%20/ /g')
    echo "$ELMANAM v$ELMAVER"
    echo ""
    echo "No entry with $ELMAQUR."
else
    echo "$ELMANAM v$ELMAVER"
    echo ""
    echo "elma-cli <search for name or organisation number>"
fi
