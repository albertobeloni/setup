# ------------------------------------------------------------------------------
# Yazi
# ------------------------------------------------------------------------------

distribution arch && packages yazi

#
# Dependencies
#

distribution arch && packages 7zip
distribution arch && packages fd
distribution arch && packages ffmpeg
distribution arch && packages imagemagick
distribution arch && packages jq
distribution arch && packages poppler
distribution arch && packages resvg
distribution arch && packages ripgrep-all
distribution arch && packages wl-clipboard

#
# USB Mounting
#

distribution arch && packages udisks2
distribution arch && packages udiskie
