new: old: {
  # Clang 16 flags "register" as an error by default
  lemon-graph = old.lemon-graph.overrideAttrs (finalAttrs: previousAttrs: {
    postPatch = "sed -i 's/register //' lemon/random.h";
  });

  # Platform-specific
  ## Undeclared Platform
  clp =
    if old.system == "aarch64-linux"
    then
      (old.clp.overrideAttrs (finalAttrs: previousAttrs: {
        meta = {
          platforms = previousAttrs.meta.platforms ++ [old.system];
        };
      }))
    else (old.clp);

  ## Clang 16 breaks Jshon
  jshon =
    if (old.stdenv.isDarwin)
    then
      old.jshon.override
      {
        stdenv = old.gccStdenv;
      }
    else (old.jshon);
  
  magic = old.magic.override {
    rev = "6e83cbe2d3348971c6b4d95b6a28eb28d446a8d2";
    sha256 = "sha256-yviA36C4KkGNM56rvZvPBi5huvKDO5Z4DG9gO5tKYCA=";
  };
}
