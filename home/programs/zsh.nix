{ pkgs }:

with pkgs;

let

  dotDir = ".config/zsh";

in {
  enable = true;

  dotDir = "${dotDir}";

  enableCompletion = true;

  enableAutosuggestions = false;

  initExtra = pkgs.my.lib.readConfig "init-extra.zsh";

  shellAliases = {
    "-g G" = "| grep -i";
    "-g H" = "| head";
    "-g L" = "| less";
    "-g NUL" = "> /dev/null 2>&1";
    "-g T" = "| tail";
    "-g F" = "| ${fzf}/bin/fzf -m";

    ".." = "cd ..";
    "..2" = "cd ../..";
    "..3" = "cd ../../..";
    "..4" = "cd ../../../..";
    "..5" = "cd ../../../../..";

    s = "sudo";
    se = "sudo -e";

    sc = "systemctl";
    scu = "systemctl --user";

    q = "quit";

    R = ". $HOME/${dotDir}/.zshrc; echo reloaded";

    cat = "${bat}/bin/bat";
    c = "${bat}/bin/bat";

    f = "${fd}/bin/fd";

    g = "${git}/bin/git";

    p = "${pass}/bin/pass";
    pg = "${pass}/bin/pass git";
    pt = "${pass}/bin/pass grep --color=never tags | grep tags | sed 's/^tags: //' | tr ' ' '\n' | sort | uniq";
    pf = "${pass}/bin/pass find";
    pft = "pass_find_tag";

    grep = "grep --color=auto";
    less = "less -R";

    la = "${exa}/bin/exa -aF";
    ll = "${exa}/bin/exa -lF";
    lla = "${exa}/bin/exa -laF";
    ls = "${exa}/bin/exa";

    pping = "${prettyping}/bin/prettyping";

    r = "${rsync}/bin/rsync -vhr --info=progress2";
    ru = "${rsync}/bin/rsync -vharzu --info=progress2";
    rud = "${rsync}/bin/rsync -vharzu --delete --info=progress2";

    yd = "${youtube-dl-light}/bin/youtube-dl";
    ydl = "${youtube-dl-light}/bin/youtube-dl --list-formats";
    ydb = "${youtube-dl-light}/bin/youtube-dl -f bestvideo+bestaudio";
    ydm = ''${youtube-dl-light}/bin/youtube-dl -f "bestvideo[height<=480]+bestaudio/best[height<=480]"'';
    yda = "${youtube-dl-light}/bin/youtube-dl --extract-audio --audio-format mp3";

    nosr = "sudo nixos-rebuild switch";
  };

  history = {
    share = false;
  };
}
