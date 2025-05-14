profiles.qol.pkg.htop:
  pkg.installed:
    - name: htop

profiles.qol.pkg.nmap:
  pkg.installed:
    - name: nmap

profiles.qol.pkg.dmg2img:
  pkg.installed:
    - name: dmg2img

# The chrome-stable sometimes wigs out and doesn't
# do hardware acceleration so we use Chromium instead.
profiles.qol.package.chromium:
  pkg.installed:
    - name: chromium

