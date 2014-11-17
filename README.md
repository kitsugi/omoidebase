omoidebase
==========

Share your memory based on location.

Developed at Couchbase Lite Hackathon at Sept 7th, 2014 in Tokyo, by team 'CouchMemories'.
Our team members worked really well together, as a result, we got the 1st prize :)

Omoidebase is an iOS application which uses Couchbase Lite and SyncGateway.
The system managed channels based on places in order to share memories among people who have visited the place.

Couchbase Server and SyncGateway
================================
You need a SyncGateway instance and Couchbase Server (or Walrus), with a bucket named 'omoidebase'.

How to use SyncGateway
=======================

A SyncGateway configuration file is included at omoidebase/sync-gateway/config.json
You can start SyncGateway specifying this file:

    bin/sync_gateway config.json

There are some 'place' documents under sync-gateway/places. You can add these document by:

  curl -XPUT  -H "Content-Type: application/json" http://localhost:4985/omoidebase/ADAA8D9E-26C4-46F8-9A39-78EFD6DDC3F5 -d @place1.json  
  curl -XPUT  -H "Content-Type: application/json" http://localhost:4985/omoidebase/2C139CE5-9B5D-4836-97A3-B25AEC49D6FB -d @place2.json  
  curl -XPUT  -H "Content-Type: application/json" http://localhost:4985/omoidebase/89B038CD-84A9-442c-95D1-0E22CAF8EB9E -d @place3.json  

You will also need to register some users to play with:

- User for SyncGateway authentication:

  curl -XPOST -H "Content-Type: application/json" http://localhost:4985/omoidebase/_user/ -d @user1.json  
  curl -XPOST -H "Content-Type: application/json" http://localhost:4985/omoidebase/_user/ -d @user2.json  

- And additional profile document to manage channels of this user:

  curl -XPUT -H "Content-Type: application/json" http://localhost:4985/omoidebase/tom -d @profile1.json  
  curl -XPUT -H "Content-Type: application/json" http://localhost:4985/omoidebase/jerry -d @profile2.json  

Xcode
=====
Copy CouchbaseLite.framework into the Frameworks directory.
If you need to change the SyncGateway IP address, you change the configuration settings.
(settings.plist)

If everything has been set properly, you can login from the iOS app and start syncing.

Event
============
Sept 7th, 2014  Hackathon in Tokyo  
Oct  7th, 2014  Couchbase Connect in San Francisco  

