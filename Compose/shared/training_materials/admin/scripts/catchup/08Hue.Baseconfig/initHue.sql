INSERT INTO "auth_user" VALUES(1,'admin','','','','sha1$63850$57ff1910ccd3826caadf97efb4cd72ce7098778f',0,1,1,'2013-08-09 09:38:05.022594','2013-03-26 10:43:37.973869');
INSERT INTO "auth_user" VALUES(2,'fred','Fred','Derf','fred@fredly.com','sha1$86444$c385cff6ca95aa451f59d589dadea276aaa863ba',0,1,0,'2013-03-26 11:06:41.463522','2013-03-26 11:05:14.878800');
INSERT INTO "auth_group" VALUES(2,'analysts');
INSERT INTO "auth_user_groups" VALUES(1,2,2);
INSERT INTO "useradmin_userprofile" VALUES('/user/fred',2,2,'HUE');
INSERT INTO "useradmin_grouppermission" VALUES(1,2,22);
INSERT INTO "useradmin_grouppermission" VALUES(2,2,23);
INSERT INTO "useradmin_grouppermission" VALUES(3,2,24);
INSERT INTO "useradmin_grouppermission" VALUES(6,2,25);
INSERT INTO "useradmin_grouppermission" VALUES(7,2,26);
INSERT INTO "useradmin_grouppermission" VALUES(8,2,27);
INSERT INTO "useradmin_grouppermission" VALUES(11,2,28);
INSERT INTO "useradmin_grouppermission" VALUES(14,2,29);

