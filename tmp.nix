input: (./. |> toString |> builtins.getFlake).inputs.${input}.outPath
