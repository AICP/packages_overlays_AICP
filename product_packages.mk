# include packages/overlays/AICP/product_packages_accent.mk
include packages/overlays/AICP/product_packages_corner_radius.mk
include packages/overlays/AICP/product_packages_icon_pack_android.mk
include packages/overlays/AICP/product_packages_icon_pack_sysui.mk
include packages/overlays/AICP/product_packages_icon_shapes.mk
# include packages/overlays/AICP/product_packages_background_themes.mk
include packages/overlays/AICP/product_packages_navbar_styles.mk
# include packages/overlays/AICP/product_packages_notif_styles.mk
# include packages/overlays/AICP/product_packages_qs_styles.mk
# include packages/overlays/AICP/product_packages_slider_styles.mk
# include packages/overlays/AICP/product_packages_nav_overlays.mk
include packages/overlays/AICP/product_packages_fonts.mk
# include packages/overlays/AICP/product_packages_volume_panels.mk

# Lawnicons
$(call inherit-product-if-exists, vendor/lawnicons/overlay.mk)
