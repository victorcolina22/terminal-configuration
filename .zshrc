export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/VictorColina/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/VictorColina/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/VictorColina/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/VictorColina/google-cloud-sdk/completion.zsh.inc'; fi

export GOOGLE_CLOUD_PROJECT=teams-devs-ia-vc

# Starship
eval "$(starship init zsh)"

# Aliases
alias lg='lazygit'
alias ls="lsd"

# Custom command to cRUL
curlt() {
  echo "📡  Generador de comando CURL"
  echo "--------------------------------"

  # Método HTTP
  read "?Método HTTP (GET, POST, PUT, PATCH, DELETE) [GET]: " method
  method=${method:-GET}

  # URL
  read "?URL del endpoint: " url

  body_file=""

  # Métodos con body
  if [[ "$method" == "POST" || "$method" == "PUT" || "$method" == "PATCH" ]]; then
    echo ""
    echo "✏️  Edita tu body JSON en nvim"
    echo "   - Guarda con :wq"
    echo "--------------------------------"

    # Crear archivo temporal válido en macOS
    tmp=$(mktemp /tmp/curl-body.XXXXXX)
    body_file="${tmp}.json"

    # Renombrar para agregar extensión .json
    mv "$tmp" "$body_file"

    echo "📝 Editando archivo temporal:"
    echo "   $body_file"
    sleep 0.3

    # Abrir en nvim
    nvim "$body_file"

    echo ""
    echo "✅ Body guardado en: $body_file"
  fi

  # Construir comando curl
  local cmd

  if [[ "$method" == "GET" ]]; then
    cmd="curl -X ${method} \"${url}\" -H \"Content-Type: application/json\" | jq"
  elif [[ "$method" == "DELETE" ]]; then
    cmd="curl -X ${method} \"${url}\" | jq"
  else
    cmd="curl -X ${method} \"${url}\" -H \"Content-Type: application/json\" --data-binary \"@${body_file}\" | jq"
  fi

  echo ""
  echo "✅ Comando preparado, se pegará en tu prompt:"
  echo "--------------------------------"
  echo "$cmd"
  echo "--------------------------------"
  echo "Presiona Enter para ejecutarlo."

  print -z -- "$cmd"
}
