#!/bin/bash

# D N S  Z o n e   T r a n s f e r   S c a n n e r 

# This spell was casted by "0xbasak". Give me a ⭐ if this spell brings you any good luck.

# This script is designed to automate the process of checking for misconfigured
# DNS servers that allow unauthorized zone transfers. It supports scanning
# multiple domains.



# Color variables for a more colorful output! 🎨
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to perform the AXFR check on a single domain
zoneTransfer() {
    
    local DOMAIN=$1
    echo -e "\n${BLUE}--- 🧙 Casting Reconnaissance Spell on Domain: ${DOMAIN} 🧙 ---${NC}"

    # First, find the authoritative Name Servers (NS) for the domain
    echo -e "${YELLOW}✨ Conjuring the domain's Name Servers...${NC}"
    NS_SERVERS=$(dig ns ${DOMAIN} +short)

    if [ -z "$NS_SERVERS" ]; then
        echo -e "${RED}❌ Could not find Name Servers for ${DOMAIN}. Skipping this realm...${NC}"
        return 1
    fi

    # Then, attempt a zone transfer from each server
    for server in $NS_SERVERS; do
        echo -e "${BLUE}🔮 Attempting a forbidden Zone Transfer ritual on server: ${server}${NC}"
        
        # Run the dig command and capture the output
        TRANSFER_OUTPUT=$(dig axfr @${server} ${DOMAIN})

        # Check if the transfer was successful by looking for a specific string in the output
        if echo "${TRANSFER_OUTPUT}" | grep -q "Transfer failed"; then
            echo -e "${YELLOW}🚫 The ritual Zone transfering to ${server} was rejected! Server is secure. ${NC}"
        elif echo "${TRANSFER_OUTPUT}" | grep -q "Transfer successful"; then
            echo -e "${GREEN}🎉 RITUAL SUCCEEDED! VULNERABILITY FOUND! Zone transfer was successful on ${server}! 🎉${NC}"
            echo "--- The full zone file is below: ---"
            echo "${TRANSFER_OUTPUT}"
            echo "-------------------------------------"
            echo -e "${RED}⚠️ This is a severe information disclosure vulnerability. Report this immediately! ⚠️${NC}"
        else
            echo -e "${YELLOW}❓ No clear success or failure message from ${server}. Manual check recommended. ${NC}"
        fi
    done
}

# --- 🚀 M A I N   L O G I C 🚀 ---

echo ".·:'''''''''''''''''''''''''''''''''''''''''''''':·.";
echo ": : ██████╗ ███████╗ ██████╗ ███╗   ██╗████████╗ : :";
echo ": : ██╔══██╗╚══███╔╝██╔═══██╗████╗  ██║╚══██╔══╝ : :";
echo ": : ██║  ██║  ███╔╝ ██║   ██║██╔██╗ ██║   ██║    : :";
echo ": : ██║  ██║ ███╔╝  ██║   ██║██║╚██╗██║   ██║    : :";
echo ": : ██████╔╝███████╗╚██████╔╝██║ ╚████║   ██║    : :";
echo ": : ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝    : :";
echo ": : DNS Zone Transfer Scanner                    : :";
echo ": :                           by 0xbasak🧙       : :";
echo "'·:..............................................:·'";

# Check if any domains were provided as arguments
if [ "$#" -eq 0 ]; then
    echo -e "${RED}🚨 Usage: $0 <domain1> <domain2> ... ${NC}"
    echo -e "${RED}   Example: $0 example.com test.net ${NC}"
    exit 1
fi

# Loop through all the provided domains and run the check
for domain in "$@"; do
    zoneTransfer "$domain"
done

echo -e "\n${GREEN}✅ The ritual is complete! Happy hunting, hunter!! ✅${NC}"
