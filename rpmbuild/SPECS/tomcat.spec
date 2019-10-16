Name:tomcat
Version: 8.0.30
Release: 1%{?dist}
License: GPL
SOURCE: %{name}-%{version}.tar.gz 
#Group: Customize / Daemons
Packager: stone@shi.com
URL:www.test.com
Summary: GUN X86_64 flume
AutoReqProv: no

%description
Flume is a distributed, reliable, and available service for efficiently collecting, aggregating, 
and moving large amounts of log data. It has a simple and flexible architecture based on 
streaming data flows. It is robust and fault tolerant with tunable reliability mechanisms 
and many failover and recovery mechanisms. It uses a simple extensible data model that allows for 
online analytic application.

%prep
#echo "在安装之前执行的命令，可以替换为创建目录 创建用户等"
rm -rf $RPM_BUILD_ROOT/*

%setup -q

%install
install -d $RPM_BUILD_ROOT/
cp -a * $RPM_BUILD_ROOT/
mkdir -p %{buildroot}/usr/lib/systemd/system
cp /root/tomcat.service %{buildroot}/usr/lib/systemd/system

%files
/usr/local/tomcat/*
/usr/lib/systemd/system/tomcat.service

%doc
%changelog
