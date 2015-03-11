name "base"
description "Base server Role"
run_list "recipe[motd]", "recipe[users]"