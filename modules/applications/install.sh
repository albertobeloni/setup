# ------------------------------------------------------------------------------
# Applications
# ------------------------------------------------------------------------------

#
# GNOME
#

distribution arch && packages nautilus
distribution arch && packages gst-libav
distribution arch && packages gst-thumbnailers
# distribution arch && packages gvfs-gphoto2
distribution arch && packages gvfs-mtp
# distribution arch && packages gvfs-smb

distribution arch && packages gnome-software

distribution arch && flathub org.gnome.Decibels
distribution arch && flathub org.gnome.Loupe
distribution arch && flathub org.gnome.Maps
distribution arch && flathub org.gnome.Papers
distribution arch && flathub org.gnome.Showtime
distribution arch && flathub org.gnome.TextEditor

#
# Office
#

# distribution arch && flathub org.libreoffice.LibreOffice

#
# Internet
#

distribution arch && flathub org.mozilla.firefox
# distribution arch && flathub org.mozilla.thunderbird

#
# Printing
#

# distribution arch && packages cups
# distribution arch && packages cups-pdf
# distribution arch && packages system-config-printer

#
# Other
#

distribution arch && flathub net.nokyan.Resources

#
# GNOME (optional)
#

# distribution arch && flathub org.gnome.Calculator
# distribution arch && flathub org.gnome.Characters
# distribution arch && flathub org.gnome.Logs
# distribution arch && flathub org.gnome.Music
# distribution arch && flathub org.gnome.Snapshot
# distribution arch && flathub org.gnome.SoundRecorder
# distribution arch && flathub org.gnome.Weather

# Evolution Data Server for GNOME Calendar and GNOME Contacts
# distribution arch && packages evolution-data-server
# distribution arch && flathub org.gnome.Calendar
# distribution arch && flathub org.gnome.Contacts

# distribution arch && flathub org.gnome.Boxes
# distribution arch && flathub org.gnome.clocks
# distribution arch && flathub org.gnome.Connections
# distribution arch && flathub org.gnome.font-viewer
# distribution arch && flathub org.gnome.SimpleScan
