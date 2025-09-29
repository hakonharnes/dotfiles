return {
  "danymat/neogen",
  opts = {
    languages = {
      php = {
        template = {
          annotation_convention = "phpdoc",
          func = {
            { nil, "/**" },
            { "description", " * $1" },
            { nil, " *" },
            { "args", " * @param $type $name" },
            { nil, " * @return void" }, -- Always include
            { nil, " */" },
          },
        },
      },
    },
  },
}
