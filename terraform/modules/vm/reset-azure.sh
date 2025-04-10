echo "logging out from Az"
az logout

echo "Clearing account records"
az account clear

echo "Show empty account list"
az account list --refresh 2>/dev/null

