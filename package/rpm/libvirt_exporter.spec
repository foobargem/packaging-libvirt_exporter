Name:		libvirt_exporter
Version:	2020.1
Release:	1%{?dist}
Summary:	Libvirt exporter for Prometheus

Group:		Monitoring
License:	MIT
URL:		https://github.com/zhangjianweibj/prometheus-libvirt-exporter
Source0:	libvirt_exporter-2020.1.tar.gz

#BuildRequires:
#Requires:

%description
Prometheus exporter for Libvirt metrics. Data is scraped by prometheus.


%prep
%setup -q


%install
rm -rf $RPM_BUILD_ROOT
mkdir -p %{buildroot}/usr/bin/
mkdir -p %{buildroot}/usr/lib/systemd/system/
mkdir -p %{buildroot}/etc/sysconfig/

cp libvirt_exporter %{buildroot}/usr/bin/libvirt_exporter
chmod 0755 %{buildroot}/usr/bin/libvirt_exporter

cp sysconfig/libvirt_exporter %{buildroot}/etc/sysconfig/

cp libvirt-exporter.service %{buildroot}/usr/lib/systemd/system/

%post
%systemd_post libvirt-exporter.service

%preun
%systemd_preun libvirt-exporter

%postun
%systemd_postun_with_restart libvirt-exporter

%files
/etc/sysconfig/libvirt_exporter
/usr/bin/libvirt_exporter
/usr/lib/systemd/system/libvirt-exporter.service


%changelog
* Fri May 8 2020 foobargem <agfe09@gmail.com> - 2020.1
- Initial packaging
