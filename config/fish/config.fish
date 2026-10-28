# 000000 чёрный        = обычный текст
# 2c4a7a синий         = команды
# 3f5a2e зелёный       = текст в кавычках
# 8a2f2f красный       = ошибки
# 7a6a50 серо-коричн.  = подсказки и комментарии

set -g fish_color_normal        000000
set -g fish_color_param         000000
set -g fish_color_valid_path    000000 --underline
set -g fish_color_operator      000000
set -g fish_color_redirection   000000 --bold
set -g fish_color_end           000000

set -g fish_color_command       2c4a7a --bold
set -g fish_color_keyword       2c4a7a --bold
set -g fish_color_option        2c4a7a

set -g fish_color_quote         3f5a2e
set -g fish_color_escape        3f5a2e
set -g fish_color_error         8a2f2f --bold
set -g fish_color_autosuggestion 7a6a50
set -g fish_color_comment       7a6a50 --italics


set -g fish_color_selection     cdb99a --background=000000
set -g fish_color_search_match  --background=e3d3b0


set -g fish_color_cwd           2c4a7a --bold
set -g fish_color_user          000000 --bold
set -g fish_color_host          2c4a7a --bold

set -g fish_pager_color_prefix       8a2f2f --bold
set -g fish_pager_color_completion   000000
set -g fish_pager_color_description  7a6a50
set -g fish_pager_color_progress     cdb99a --background=000000
set -g fish_pager_color_selected_background --background=e3d3b0


if status is-interactive
	habit
end
