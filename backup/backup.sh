#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Uso: $0 PASTA_ORIGEM PASTA_DESTINO [QUANTOS_MANTER]"
  exit 1
fi

if [ ! -d "$1" ]; then
  echo "ERRO: a pasta de origem não existe: $1" >&2
  exit 1
fi

ORIGEM="$1"
DESTINO="$2"
MANTER="${3:-7}"

mkdir -p "$DESTINO"

DATA=$(date +%Y%m%d-%H%M%S)
ARQUIVO="$DESTINO/backup_$DATA.tar.gz"

tar -czf "$ARQUIVO" -C "$(dirname "$ORIGEM")" "$(basename "$ORIGEM")"

if tar -tzf "$ARQUIVO" > /dev/null; then
  echo "Backup criado e verificado: $ARQUIVO"
else
  rm -f "$ARQUIVO"
  echo "ERRO: o backup ficou corrompido e foi removido." >&2
  exit 1
fi

ls -1t "$DESTINO"/backup_*.tar.gz | tail -n +"$((MANTER + 1))" | xargs -r rm -f --
