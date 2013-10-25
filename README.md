Phaxio API Proxy Service
========================

Our API proxy service is now available at apiproxy.phaxio.com.  This is a service you can use to test out Phaxio using the same code you already have for other providers.  
Just change your API endpoint, username, and password and you're in business!


Interfax
========
You can access the web service that mimics Interfax at http://apiproxy.phaxio.com/interfax/wsdl.  Substitute your Interfax username for your Phaxio API key and Interfax password for your Phaxio API secret.

The following operations are implemented:
- Sendfax
- SendCharFax 
- GetFaxImage
- CancelFax
- FaxStatusEx

The only caveat in our implementation of the service is that for FaxStatusEx, LastTransactionID must be a fax that exists in your account.  Documentation for the proxy services will be on our site shortly, but I wanted to get this to you as soon as possible for testing.  Additionally, you may wish to consult the code for the proxy service, as it is open source.  You may find that here:  https://github.com/phaxio/phaxio-apiproxy

Please let us know if you have any issues with the service by filing issues directly on the repository, or by email at support@phaxio.com.

Faxage
======
Coming soon!

Metrofax
========
Coming soon!
