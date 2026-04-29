#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# Habilita ALB access logs nos ALBs FrontConsig
# Uso: ./scripts/enable-alb-access-logs.sh
# Pré-requisito: awsp akrk-dev
###############################################################################

BUCKET="akrk-alb-access-logs-528547794217"
REGION="us-east-1"

echo "Buscando ALBs FrontConsig na conta..."

# Lista todos os ALBs e filtra por nome frontconsig/solis/td-frontconsig
ALBS=$(aws elbv2 describe-load-balancers \
  --region "$REGION" \
  --query 'LoadBalancers[?contains(LoadBalancerName, `frontconsig`) || contains(LoadBalancerName, `solis`) || contains(LoadBalancerName, `crm`) || contains(LoadBalancerName, `unico`)].{Name:LoadBalancerName,Arn:LoadBalancerArn}' \
  --output json)

COUNT=$(echo "$ALBS" | jq length)
echo "Encontrados: $COUNT ALBs"
echo ""

echo "$ALBS" | jq -r '.[] | "\(.Name) -> \(.Arn)"'
echo ""

read -rp "Habilitar access logs em todos? (y/N): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
  echo "Abortado."
  exit 0
fi

echo "$ALBS" | jq -c '.[]' | while read -r ALB; do
  NAME=$(echo "$ALB" | jq -r '.Name')
  ARN=$(echo "$ALB" | jq -r '.Arn')

  echo "Habilitando access logs: $NAME"
  aws elbv2 modify-load-balancer-attributes \
    --load-balancer-arn "$ARN" \
    --attributes \
      Key=access_logs.s3.enabled,Value=true \
      Key=access_logs.s3.bucket,Value="$BUCKET" \
      Key=access_logs.s3.prefix,Value="$NAME" \
    --region "$REGION" \
    --output text > /dev/null

  echo "  OK"
done

echo ""
echo "Concluido. Logs serao entregues em s3://$BUCKET/<alb-name>/AWSLogs/..."
