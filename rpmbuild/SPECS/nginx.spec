Name:nginx		
Version:1.12.2	
Release:	1
Summary:nginx	

#Group:		
License:GPL	
URL:	www.test.com	
Source0:	nginx-1.12.2.tar.gz

#BuildRequires:	
#Requires:	

%description
Welcome to Use Nginx

%prep
%setup -q

%post
useradd nginx

%build
./configure
make %{?_smp_mflags}


%install
make install DESTDIR=%{buildroot}
mkdir -p %{buildroot}/usr/lib/systemd/system
cp /root/nginx.service %{buildroot}/usr/lib/systemd/system


%files
%doc
/usr/lib/systemd/system/nginx.service
/usr/local/nginx/*


%changelog

