CREATE DATABASE /*!32312 IF NOT EXISTS*/ `vspheredb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `vspheredb`;

--
-- Table structure for table `datastore`
--

DROP TABLE IF EXISTS `datastore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `datastore` (
  `uuid` varbinary(20) NOT NULL,
  `vcenter_uuid` varbinary(16) NOT NULL,
  `maintenance_mode` enum('normal','enteringMaintenance','inMaintenance') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `is_accessible` enum('y','n') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `capacity` bigint unsigned DEFAULT NULL,
  `free_space` bigint unsigned DEFAULT NULL,
  `uncommitted` bigint unsigned DEFAULT NULL,
  `multiple_host_access` enum('y','n') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `ts_last_forced_refresh` bigint DEFAULT NULL,
  PRIMARY KEY (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datastore`
--

LOCK TABLES `datastore` WRITE;
/*!40000 ALTER TABLE `datastore` DISABLE KEYS */;
INSERT INTO `datastore` VALUES (_binary 'ï¿½ï¿½]ï¿½ï¿½ï¿½\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï',NULL,'y',3590055788544,1965910130688,956095986075,NULL,NULL);
/*!40000 ALTER TABLE `datastore` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_physical_nic`
--

DROP TABLE IF EXISTS `host_physical_nic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `host_physical_nic` (
  `host_uuid` varbinary(20) NOT NULL,
  `nic_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `auto_negotiate_supported` enum('y','n') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `device` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `driver` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `link_speed_mb` int unsigned DEFAULT NULL,
  `link_duplex` enum('y','n') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `mac_address` varchar(17) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `pci` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `vcenter_uuid` varbinary(16) NOT NULL,
  PRIMARY KEY (`host_uuid`,`nic_key`),
  KEY `vcenter_uuid` (`vcenter_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_physical_nic`
--

LOCK TABLES `host_physical_nic` WRITE;
/*!40000 ALTER TABLE `host_physical_nic` DISABLE KEYS */;
INSERT INTO `host_physical_nic` VALUES (_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿','key-vim.host.PhysicalNic-vmnic0','y','vmnic0','bnx2',1000,'y','00:22:19:68:9a:d9','0000:01:00.0',_binary 'LLED\0CJï¿½5ï¿½\ï'),(_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿','key-vim.host.PhysicalNic-vmnic1','y','vmnic1','bnx2',1000,'y','00:22:19:68:9a:db','0000:01:00.1',_binary 'LLED\0CJï¿½5ï¿½\ï'),(_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿','key-vim.host.PhysicalNic-vmnic2','y','vmnic2','bnx2',NULL,NULL,'00:22:19:68:9a:dd','0000:02:00.0',_binary 'LLED\0CJï¿½5ï¿½\ï'),(_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿','key-vim.host.PhysicalNic-vmnic3','y','vmnic3','bnx2',NULL,NULL,'00:22:19:68:9a:df','0000:02:00.1',_binary 'LLED\0CJï¿½5ï¿½\ï');
/*!40000 ALTER TABLE `host_physical_nic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_quick_stats`
--

DROP TABLE IF EXISTS `host_quick_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `host_quick_stats` (
  `uuid` varbinary(20) NOT NULL,
  `distributed_cpu_fairness` int DEFAULT NULL,
  `distributed_memory_fairness` int DEFAULT NULL,
  `overall_cpu_usage` int unsigned DEFAULT NULL,
  `overall_memory_usage_mb` int unsigned DEFAULT NULL,
  `uptime` int unsigned DEFAULT NULL,
  `vcenter_uuid` varbinary(16) NOT NULL,
  PRIMARY KEY (`uuid`),
  KEY `vcenter_uuid` (`vcenter_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_quick_stats`
--

LOCK TABLES `host_quick_stats` WRITE;
/*!40000 ALTER TABLE `host_quick_stats` DISABLE KEYS */;
INSERT INTO `host_quick_stats` VALUES (_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',NULL,NULL,1625,19182,4760028,_binary 'LLED\0CJï¿½5ï¿½\ï');
/*!40000 ALTER TABLE `host_quick_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_sensor`
--

DROP TABLE IF EXISTS `host_sensor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `host_sensor` (
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `host_uuid` varbinary(20) NOT NULL,
  `vcenter_uuid` varbinary(16) NOT NULL,
  `health_state` enum('green','yellow','unknown','red') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `current_reading` int NOT NULL,
  `unit_modifier` smallint NOT NULL,
  `base_units` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `rate_units` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `sensor_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`host_uuid`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_sensor`
--

LOCK TABLES `host_sensor` WRITE;
/*!40000 ALTER TABLE `host_sensor` DISABLE KEYS */;
INSERT INTO `host_sensor` VALUES ('Disk Drive Bay 1 Cable SAS A 0 --- 0.26.1.144',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','storage'),('Disk Drive Bay 1 Cable SAS B 0 --- 0.26.1.145',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','storage'),('Disk Drive Bay 1 Drive 0 --- 0.26.1.128',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','storage'),('Disk Drive Bay 1 Drive 1 --- 0.26.1.129',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','storage'),('Disk Drive Bay 1 Drive 2 --- 0.26.1.130',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','storage'),('Disk Drive Bay 1 Drive 3 --- 0.26.1.131',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','storage'),('Disk Drive Bay 1 Drive 4 --- 0.26.1.132',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','storage'),('Disk Drive Bay 1 Drive 5 --- 0.26.1.133',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','storage'),('Disk Drive Bay 1 Presence  0 --- 0.26.1.86',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','storage'),('Disk Drive Bay 3 ROMB Battery 0 --- 0.26.3.17',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',0,0,'sensor-discrete','none','battery'),('Power Supply 1 Current --- 0.10.1.148',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',47,-2,'Amps','none','power'),('Power Supply 1 Presence 0 --- 0.10.1.84',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','power'),('Power Supply 1 Status 0 --- 0.10.1.100',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','power'),('Power Supply 1 Voltage --- 0.10.1.150',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',23000,-2,'Volts','none','voltage'),('Power Supply 2 Current --- 0.10.2.149',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',40,-2,'Amps','none','power'),('Power Supply 2 Presence 0 --- 0.10.2.85',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','power'),('Power Supply 2 Status 0 --- 0.10.2.101',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','power'),('Power Supply 2 Voltage --- 0.10.2.151',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',23000,-2,'Volts','none','voltage'),('Processor 1 0.75 VTT PG 0 --- 0.3.1.21',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('Processor 1 1.8 PLL PG 0 --- 0.3.1.36',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('Processor 1 MEM PG 0 --- 0.3.1.30',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('Processor 1 Presence 0 --- 0.3.1.80',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','processor'),('Processor 1 Status 0 --- 0.3.1.96',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',128,0,'sensor-discrete','none','processor'),('Processor 1 VCORE PG 0 --- 0.3.1.18',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('Processor 1 VTT PG 0 --- 0.3.1.32',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('Processor 2 0.75VTT PG 0 --- 0.3.2.20',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('Processor 2 1.8 PLL PG 0 --- 0.3.2.34',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('Processor 2 MEM PG 0 --- 0.3.2.27',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('Processor 2 Presence 0 --- 0.3.2.81',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','processor'),('Processor 2 Status 0 --- 0.3.2.97',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',128,0,'sensor-discrete','none','processor'),('Processor 2 VCORE PG 0 --- 0.3.2.19',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('Processor 2 VTT PG 0 --- 0.3.2.31',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('System Board 1 0.9V PG 0 --- 0.7.1.33',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('System Board 1 1.05V PG 0 --- 0.7.1.43',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('System Board 1 1.0V AUX PG 0 --- 0.7.1.42',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('System Board 1 1.0V LOM PG 0 --- 0.7.1.41',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('System Board 1 1.1V PG 0 --- 0.7.1.40',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('System Board 1 1.5V PG 0 --- 0.7.1.23',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('System Board 1 1.8V PG 0 --- 0.7.1.24',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('System Board 1 3.3V PG 0 --- 0.7.1.25',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('System Board 1 5V PG 0 --- 0.7.1.26',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('System Board 1 8.0V PG 0 --- 0.7.1.37',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'assert-discrete','none','voltage'),('System Board 1 Ambient Temp --- 0.7.1.14',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',2000,-2,'degrees C','none','temperature'),('System Board 1 CMOS Battery 0 --- 0.7.1.16',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',0,0,'sensor-discrete','none','battery'),('System Board 1 FAN MOD 1A RPM --- 0.7.1.48',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',432000,-2,'RPM','none','fan'),('System Board 1 FAN MOD 1B RPM --- 0.7.1.54',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',300000,-2,'RPM','none','fan'),('System Board 1 FAN MOD 2A RPM --- 0.7.1.49',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',432000,-2,'RPM','none','fan'),('System Board 1 FAN MOD 2B RPM --- 0.7.1.55',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',300000,-2,'RPM','none','fan'),('System Board 1 FAN MOD 3A RPM --- 0.7.1.50',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',432000,-2,'RPM','none','fan'),('System Board 1 FAN MOD 3B RPM --- 0.7.1.56',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',300000,-2,'RPM','none','fan'),('System Board 1 FAN MOD 4A RPM --- 0.7.1.51',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',432000,-2,'RPM','none','fan'),('System Board 1 FAN MOD 4B RPM --- 0.7.1.57',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',300000,-2,'RPM','none','fan'),('System Board 1 FAN MOD 5A RPM --- 0.7.1.52',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',432000,-2,'RPM','none','fan'),('System Board 1 FAN MOD 5B RPM --- 0.7.1.58',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',300000,-2,'RPM','none','fan'),('System Board 1 FAN MOD 6A RPM --- 0.7.1.53',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',432000,-2,'RPM','none','fan'),('System Board 1 FAN MOD 6B RPM --- 0.7.1.59',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',300000,-2,'RPM','none','fan'),('System Board 1 Fan Redundancy 0 --- 0.7.1.117',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'redundancy-discrete','none','fan'),('System Board 1 HEATSINK PRES 0 --- 0.7.1.82',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','systemBoard'),('System Board 1 Intrusion 0 --- 0.7.1.115',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',0,0,'sensor-discrete','none','systemBoard'),('System Board 1 OS Watchdog 0 --- 0.7.1.113',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',0,0,'sensor-discrete','none','watchdog'),('System Board 1 PS Redundancy 0 --- 0.7.1.116',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'redundancy-discrete','none','power'),('System Board 1 Power Optimized 0 --- 0.7.1.153',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','unknown',1,0,'sensor-discrete','none','systemBoard'),('System Board 1 RISER1 PRES 0 --- 0.7.1.92',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','systemBoard'),('System Board 1 RISER2 PRES 0 --- 0.7.1.91',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','systemBoard'),('System Board 1 Riser Config 0 --- 0.7.1.102',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','cable'),('System Board 1 STOR ADAPT PRES 0 --- 0.7.1.90',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','systemBoard'),('System Board 1 System Level --- 0.7.1.152',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',20300,-2,'Watts','none','systemBoard'),('System Board 1 Test Temp',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',25000,-2,'degrees C','none','temperature'),('System Board 1 USB CABLE PRES 0 --- 0.7.1.89',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','systemBoard'),('System Board 1 iDRAC6 Ent PRES 0 --- 0.7.1.112',_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','green',1,0,'sensor-discrete','none','systemBoard');
/*!40000 ALTER TABLE `host_sensor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_system`
--

DROP TABLE IF EXISTS `host_system`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `host_system` (
  `uuid` varbinary(20) NOT NULL,
  `host_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `vcenter_uuid` varbinary(16) NOT NULL,
  `product_api_version` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `product_full_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `bios_version` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `bios_release_date` datetime DEFAULT NULL,
  `sysinfo_vendor` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `sysinfo_model` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `sysinfo_uuid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `service_tag` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `hardware_cpu_model` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `hardware_cpu_mhz` int unsigned NOT NULL,
  `hardware_cpu_packages` smallint unsigned NOT NULL,
  `hardware_cpu_cores` smallint unsigned NOT NULL,
  `hardware_cpu_threads` smallint unsigned NOT NULL,
  `hardware_memory_size_mb` int unsigned NOT NULL,
  `hardware_num_hba` smallint unsigned NOT NULL,
  `hardware_num_nic` smallint unsigned NOT NULL,
  `runtime_power_state` enum('poweredOff','poweredOn','standBy','unknown') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `das_host_state` enum('connectedToMaster','election','fdmUnreachable','hostDown','initializationError','master','networkIsolated','networkPartitionedFromMaster','uninitializationError','uninitialized') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `custom_values` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_system`
--

LOCK TABLES `host_system` WRITE;
/*!40000 ALTER TABLE `host_system` DISABLE KEYS */;
INSERT INTO `host_system` VALUES (_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿','net-example-demo.',_binary 'LLED\0CJï¿½5ï¿½\ï','6.5','VMware ESXi 6.5.0 build-18678235','1.2.3','2013-07-23 00:00:00','Dell Inc.','PowerEdge R610','badfood1-0012-1a23-4444-bacc4d47312a','1DC5G4J','Intel(R) Xeon(R) CPU           E5540  @ 2.50GHz',2527,2,8,16,49132,7,4,'poweredOn',NULL,NULL);
/*!40000 ALTER TABLE `host_system` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_virtual_nic`
--

DROP TABLE IF EXISTS `host_virtual_nic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `host_virtual_nic` (
  `host_uuid` varbinary(20) NOT NULL,
  `nic_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `net_stack_instance_key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `port` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `portgroup` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `mac_address` varchar(17) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `mtu` int DEFAULT NULL,
  `ipv4_address` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `ipv4_subnet_mask` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `ipv6_address` varchar(47) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `ipv6_prefic_length` int DEFAULT NULL,
  `ipv6_dad_state` enum('deprecated','duplicate','inaccessible','invalid','preferred','tentative','unknown') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `ipv6_origin` enum('dhcp','linklayer','manual','other','random') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `dv_connection_cookie` int DEFAULT NULL,
  `dv_portgroup_key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `dv_port_key` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `dv_switch_uuid` varchar(47) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `device` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `tso_enabled` enum('y','n') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `vcenter_uuid` varbinary(16) NOT NULL,
  PRIMARY KEY (`host_uuid`,`nic_key`),
  KEY `vcenter_uuid` (`vcenter_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_virtual_nic`
--

LOCK TABLES `host_virtual_nic` WRITE;
/*!40000 ALTER TABLE `host_virtual_nic` DISABLE KEYS */;
INSERT INTO `host_virtual_nic` VALUES (_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿','key-vim.host.VirtualNic-vmk0',NULL,'key-vim.host.PortGroup.Port-33554436','Management Network','00:22:19:68:9a:d9',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'vmk0',NULL,_binary 'LLED\0CJï¿½5ï¿½\ï'),(_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿','key-vim.host.VirtualNic-vmk1',NULL,'key-vim.host.PortGroup.Port-50331652','net-monitor','00:50:56:64:69:cc',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'vmk1',NULL,_binary 'LLED\0CJï¿½5ï¿½\ï'),(_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿','key-vim.host.VirtualNic-vmk2',NULL,'key-vim.host.PortGroup.Port-67108866','Testing MS','00:50:56:62:d5:37',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'vmk2',NULL,_binary 'LLED\0CJï¿½5ï¿½\ï'),(_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿','key-vim.host.VirtualNic-vmk3',NULL,'key-vim.host.PortGroup.Port-100663300','Sales-Demo-LAN','00:50:56:6e:e9:07',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'vmk3',NULL,_binary 'LLED\0CJï¿½5ï¿½\ï');
/*!40000 ALTER TABLE `host_virtual_nic` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `vcenter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vcenter` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `instance_uuid` varbinary(16) NOT NULL,
  `trust_store_id` int unsigned DEFAULT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `version` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `os_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `api_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `api_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `api_version` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `build` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `vendor` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `product_line` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `license_product_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `license_product_version` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `locale_build` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `locale_version` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `instance_uuid` (`instance_uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vcenter`
--

LOCK TABLES `vcenter` WRITE;
/*!40000 ALTER TABLE `vcenter` DISABLE KEYS */;
INSERT INTO `vcenter` VALUES (1,_binary 'LLED\0CJï¿½5ï¿½\ï',NULL,'192.168.58.123','6.5.0','vmnix-x86','VMware ESXi','HostAgent','6.5','5969303','VMware, Inc.','embeddedEsx','VMware ESX Server','6.0','000','INTL');
/*!40000 ALTER TABLE `vcenter` ENABLE KEYS */;
UNLOCK TABLES;
--
-- Table structure for table `object`
--

DROP TABLE IF EXISTS `object`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `object` (
  `uuid` varbinary(20) NOT NULL,
  `vcenter_uuid` varbinary(16) NOT NULL,
  `moref` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `object_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `object_type` enum('ComputeResource','ClusterComputeResource','Datacenter','Datastore','DatastoreHostMount','DistributedVirtualPortgroup','DistributedVirtualSwitch','Folder','HostMountInfo','HostSystem','Network','OpaqueNetwork','ResourcePool','StoragePod','VirtualApp','VirtualMachine','VmwareDistributedVirtualSwitch') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `overall_status` enum('gray','green','yellow','red') CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `level` tinyint unsigned NOT NULL,
  `parent_uuid` varbinary(20) DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  UNIQUE KEY `vcenter_moref` (`vcenter_uuid`,`moref`),
  KEY `object_type` (`object_type`),
  KEY `object_name` (`object_name`(64)),
  KEY `object_parent` (`parent_uuid`),
  -- CONSTRAINT `object_parent` FOREIGN KEY (`parent_uuid`) REFERENCES `object` (`uuid`),
  CONSTRAINT `object_vcenter` FOREIGN KEY (`vcenter_uuid`) REFERENCES `vcenter` (`instance_uuid`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `object`
--

LOCK TABLES `object` WRITE;
/*!40000 ALTER TABLE `object` DISABLE KEYS */;
INSERT INTO `object` VALUES (_binary '\0\"ï¿½K>ï¿½4~ï¿½}ï¿½3',_binary 'LLED\0CJï¿½5ï¿½\ï','HaNetwork-Foreman Intern','Foreman Intern','Network','green',3,_binary 'ï¿½xoï¿½Wï¿½nï¿½\ï¿'),(_binary 'ï¿½ï¿½ï¿½vï¿½ï¿½\Ø',_binary 'LLED\0CJï¿½5ï¿½\ï','20','example-env','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary '\rrÉ¾UnpRï¿½a\'ï¿½\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','ha-folder-root','root','Folder','green',0,NULL),(_binary 'ï¿½ï¿½d~ï¿½ï¿½@:ï¿½',_binary 'LLED\0CJï¿½5ï¿½\ï','HaNetwork-VM Network','VM Network','Network','green',3,_binary 'ï¿½xoï¿½Wï¿½nï¿½\ï¿'),(_binary '1+J+ï¿½ï¿½oï¿½Xï¿½\ï',_binary 'LLED\0CJï¿½5ï¿½\ï','ha-folder-host','host','Folder','green',2,_binary '{ì›“ï¿½l$ï¿½8yï¿½cw'),(_binary '1ï¿½ï¿½7ï¿½]Ä´ï¿½\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','ha-compute-res','net-example-demo.','ComputeResource','green',3,_binary '1+J+ï¿½ï¿½oï¿½Xï¿½\ï'),(_binary '7ï¿½Fï¿½ï¿½\'Dï¿½H\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','27','example-net-share','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary '9ï¿½4ï¿½ï¿½Ï¶Pj@l\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','ha-host','net-example-demo.','HostSystem','green',4,_binary '1ï¿½ï¿½7ï¿½]Ä´ï¿½\ï¿'),(_binary 'Gu/ï¿½.t!ï¿½ï¿½z',_binary 'LLED\0CJï¿½5ï¿½\ï','5','example-demo-icinga2b','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary 'Mï¿½Cï¿½_iï¿½>,1Dn3',_binary 'LLED\0CJï¿½5ï¿½\ï','28','example-net-icinga2a','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary '\\jjï¿½ï¿½Dï¿½uï¿½\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','18','example-demo-rt','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary '{ì›“ï¿½l$ï¿½8yï¿½cw',_binary 'LLED\0CJï¿½5ï¿½\ï','ha-datacenter','ha-datacenter','Datacenter','green',1,_binary '\rrÉ¾UnpRï¿½a\'ï¿½\ï¿'),(_binary '~ï¿½Ò¹ï¿½ï¿½d4/`\ï',_binary 'LLED\0CJï¿½5ï¿½\ï','7','example-demo-windows','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary 'Ë¨ï¿½dç€†ï¿½ï¿½ï¿½\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','2','example-demo-elastic','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary 'Í’ï¿½ï¿½ï¿½ï¿½\'ï¿½',_binary 'LLED\0CJï¿½5ï¿½\ï','8','example-net-mysql','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary 'ï¿½Jï¿½Gï¿½ï¿½aSn\ï',_binary 'LLED\0CJï¿½5ï¿½\ï','26','test1-foreman','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary 'ï¿½	@ï¿½ï¿½$ï¿½%0\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','33','example-net-graphing','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½',_binary 'LLED\0CJï¿½5ï¿½\ï','ha-folder-vm','vm','Folder','green',2,_binary '{ì›“ï¿½l$ï¿½8yï¿½cw'),(_binary 'ï¿½\ZSï¿½\\ï¿½uBï¿½',_binary 'LLED\0CJï¿½5ï¿½\ï','HaNetwork-Example Demo LAN','Example Demo LAN','Network','green',3,_binary 'ï¿½xoï¿½Wï¿½nï¿½\ï¿'),(_binary 'ï¿½\"rzODT\r+@ï¿½ï¿½',_binary 'LLED\0CJï¿½5ï¿½\ï','32','example-net-collabora','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary 'ï¿½E^gG4ï¿½ï¿½P6ï¿½',_binary 'LLED\0CJï¿½5ï¿½\ï','3','example-demo-icinga2a','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary 'ï¿½Sï¿½*ï¿½ï¿½^z\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','6','example-demo-ansible','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary 'ï¿½Zï¿½<Hï¿½ï¿½U6c\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','22','example-demo-foreman','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary 'ï¿½oï¿½ï¿½Iï¿½ï¿½ï¿½',_binary 'LLED\0CJï¿½5ï¿½\ï','40','example-net-graylog','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary 'ï¿½xoï¿½Wï¿½nï¿½\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','ha-folder-network','network','Folder','green',2,_binary '{ì›“ï¿½l$ï¿½8yï¿½cw'),(_binary 'ï¿½ï¿½\0Úï¿½ï¿½Lï¿½',_binary 'LLED\0CJï¿½5ï¿½\ï','ha-folder-datastore','datastore','Folder','green',2,_binary '{ì›“ï¿½l$ï¿½8yï¿½cw'),(_binary 'ï¿½ï¿½/ï¿½eï¿½ï¿½D',_binary 'LLED\0CJï¿½5ï¿½\ï','1','example-net-monitor','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary 'ï¿½ï¿½]ï¿½ï¿½ï¿½\ï¿',_binary 'LLED\0CJï¿½5ï¿½\ï','59d4e9c9-55c22923-ab7a-002219689ad9','datastore1','Datastore','green',3,_binary 'ï¿½ï¿½\0Úï¿½ï¿½Lï¿½'),(_binary 'ï¿½ï¿½rï¿½ï¿½\"yÓœï¿½',_binary 'LLED\0CJï¿½5ï¿½\ï','37','example-pi-hole2','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary 'ï¿½ï¿½ï¿½É¾Xï¿½ï¿½$}',_binary 'LLED\0CJï¿½5ï¿½\ï','35','example-net-tools','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½'),(_binary 'ï¿½ï¿½ï¿½ï¿½ï¿½Yï¿½L',_binary 'LLED\0CJï¿½5ï¿½\ï','HaNetwork-Net-Monitor-DHCP','Net-Monitor-DHCP','Network','green',3,_binary 'ï¿½xoï¿½Wï¿½nï¿½\ï¿'),(_binary 'ï¿½ï¿½ï¿½ï¿½ï¿½fï¿½\ï',_binary 'LLED\0CJï¿½5ï¿½\ï','29','example-net-icinga2b','VirtualMachine','green',3,_binary 'ï¿½-ï¿½ï¿½ï¿½5jï¿½');
/*!40000 ALTER TABLE `object` ENABLE KEYS */;
UNLOCK TABLES;
