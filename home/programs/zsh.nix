{ pkgs }:

with pkgs;

let

  dotDir = ".config/zsh";

in {
  enable = true;

  dotDir = "${dotDir}";

  enableCompletion = true;

  enableAutosuggestions = false;

  shellAliases = {
    "-g G" = "| grep -i";
    "-g H" = "| head";
    "-g L" = "| less";
    "-g NUL" = "> /dev/null 2>&1";
    "-g T" = "| tail";

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

    grep = "grep --color=always";
    less = "less -R";

    la = "${exa}/bin/exa -aF";
    ll = "${exa}/bin/exa -lF";
    lla = "${exa}/bin/exa -laF";
    ls = "${exa}/bin/exa";

    pping = "${prettyping}/bin/prettyping";

    r = "${rsync}/bin/rsync -vh --info=progress2";
    ru = "${rsync}/bin/rsync -vhazu --info=progress2";
    rud = "${rsync}/bin/rsync -vhazu --delete --info=progress2";

    yd = "${youtube-dl-light}/bin/youtube-dl";
    ydl = "${youtube-dl-light}/bin/youtube-dl --list-formats";
    ydb = "${youtube-dl-light}/bin/youtube-dl -f bestvideo+bestaudio";
    ydm = ''${youtube-dl-light}/bin/youtube-dl -f "bestvideo[height<=480]+bestaudio/best[height<=480]"'';
    yda = "${youtube-dl-light}/bin/youtube-dl --extract-audio --audio-format mp3";

    va = "${vagrant}/bin/vagrant";
    vau = "${vagrant}/bin/vagrant up";
    vap = "${vagrant}/bin/vagrant provision";
    vad = "${vagrant}/bin/vagrant destroy";
    vah = "${vagrant}/bin/vagrant halt";
    vas = "${vagrant}/bin/vagrant suspend";
    var = "${vagrant}/bin/vagrant resume";
    varl = "${vagrant}/bin/vagrant reload";
    vast = "${vagrant}/bin/vagrant status";
    vag = "${vagrant}/bin/vagrant global-status";
    vash = "${vagrant}/bin/vagrant ssh";

    s7vpn = "sudo ${openvpn}/bin/openvpn $HOME/s7/client.ovpn";
  };

  history = {
    share = false;
  };
}
