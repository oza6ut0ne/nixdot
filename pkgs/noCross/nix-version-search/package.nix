{
  writeShellApplication,
  curl,
  fzf,
  gawk,
  w3m,
}:

writeShellApplication {
  name = "nix-version-search";

  runtimeInputs = [
    curl
    fzf
    gawk
    w3m
  ];

  text = ''
    SORT_BY_VERSION="cat"
    FUZZY_SELECT="cat"

    usage() {
      echo "Usage: $(basename "$0") [-s] [-f] <package>" >&2
    }

    while getopts sf OPT
    do
      case $OPT in
        s) SORT_BY_VERSION="(sed -u 1q; sort -k2V)" ;;
        f) FUZZY_SELECT="fzf --tac --no-sort --header-lines=1 --nth 2 --accept-nth=3" ;;
        *) usage; exit 1 ;;
      esac
    done
    shift $((OPTIND - 1))

    if [ "$#" -ne 1 ]; then
      usage
      exit 1
    fi

    url="https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package=$1"

    curl -s "$url" \
      | w3m -dump -T text/html \
      | awk '/^ *Package +Version +Revision +Date/ { should_print=1; print; next } \
             should_print && /^$/ { exit } \
             should_print' \
      | eval "$SORT_BY_VERSION" \
      | eval "$FUZZY_SELECT"
  '';
}
