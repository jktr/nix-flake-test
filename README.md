# nixos-container example flakes

`nixos-container` recently gained the `--flake`
option. This repo contains some example flakes
that are compatible with this feature.

To opt-in to the experimental flake features, extend your
`nixos-configuration.nix` with the following. You may need
to set `nix.trustedUsers` as well.

```nix
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
```

This enables the new `nix flake` command.

Place your new `flake.nix` file in your repo's root.
You can then  (re-)generate a `flake.lock` file to place
besidet it with 

```
$ nix flake update
```

After uploading your git repo, you should be able to run your
new flake-based nixos-container like this:

```
$ sudo nixos-container create mycontainer \
  --flake "github:jktr/nixos-container-example-flakes \
    && sudo nixos-container start mycontainer
```

When developing a flake-based container, you probably want
to forego instantiating the container and just try to build
it first. You can do that like this:

```
$ nix build --no-link \
  "github:jktr/nixos-container-example-flakes#nixosConfigurations.container.config.system.build.toplevel"
```

Note that you can also specify fixed versions of flakes as follows.
This is particularly helpful when developing these container flakes,
as build failures for unversioned flake specifiers are still cached.

```
github:jktr/nixos-container-example-flakes
github:jktr/nixos-container-example-flakes/1e48145fd5ee8c495766afaf828f53b0ffea605a

```
