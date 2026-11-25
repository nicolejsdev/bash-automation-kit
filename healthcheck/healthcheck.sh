#!/usr/bin/env bash
set -euo pipefail

verificar_servico() {
  local nome="$1"
  if systemctl is-active --quiet "$nome"; then
    echo "OK: serviço $nome está rodando"
  else
    echo "FALHA: serviço $nome está parado"
  fi
}

verificar_servico cron
verificar_servico servico-inexistente
