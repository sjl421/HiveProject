--HBase_Hive  ->  HDFS_Hive（bca）
CREATE EXTERNAL TABLE bca(ROWKEY BINARY,S2 STRING,S3a STRING,S7 STRING,S8a STRING,S8b STRING,YR STRING, CX ARRAY<STRING>,IQS ARRAY<STRING>,CD ARRAY<STRING>,GJ ARRAY<STRING>,JK ARRAY<STRING>,FM STRING,RY ARRAY<STRING>,R_B1a ARRAY<STRING>,R_B2a ARRAY<STRING>,R_B3a ARRAY<STRING>,B3b ARRAY<STRING>,G1 STRING,S9 STRING,S10 STRING,Q2a STRING,Q2b STRING,Q2c STRING,B1 ARRAY<STRING>,B2 ARRAY<STRING>,B3 ARRAY<STRING>,B4 ARRAY<STRING>,B5 ARRAY<STRING>,B6 ARRAY<STRING>,B7 ARRAY<STRING>,B8 ARRAY<STRING>,A_B1a ARRAY<STRING>,A_B2a ARRAY<STRING>,A_B3a ARRAY<STRING>,B4a ARRAY<STRING>,C1 ARRAY<STRING>,C2 ARRAY<STRING>,C3 ARRAY<STRING>,C4 ARRAY<STRING>,C5 ARRAY<STRING>,A1 ARRAY<STRING>,A2 ARRAY<STRING>,A3 ARRAY<STRING>,G ARRAY<STRING>,RDINT1 ARRAY<STRING>,BRDINT2 ARRAY<STRING>,BRDINT3 ARRAY<STRING>,IQSINT3 ARRAY<STRING>,IQSINT2 ARRAY<STRING>,IQSINT1 ARRAY<STRING>,S11 STRING,S12 STRING,S13 STRING,sid BINARY,ATT ARRAY<STRING>,IMG ARRAY<STRING>,A4 ARRAY<STRING>,C6 ARRAY<STRING>,S3b STRING,attimg1 ARRAY<STRING>,attimg2 ARRAY<STRING>,attimg3 ARRAY<STRING>)
PARTITIONED BY (mth STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
COLLECTION ITEMS TERMINATED BY ','
MAP KEYS TERMINATED BY ':'
STORED AS orc

set hive.optimize.sort.dynamic.partition=true;  //分区大于100的时候使用
set mapreduce.reduce.memory.mb=5120;
set mapreduce.reduce.java.opts=-Xmx4096m;
set mapreduce.map.memory.mb=3072;
set mapreduce.map.java.opts=-Xmx2048m;

--导入数据
INSERT OVERWRITE TABLE bca
PARTITION (mth)
SELECT ROWKEY,S2,S3a,S7,S8a,S8b,YR,CX,IQS,CD,GJ,JK,FM,RY,R_B1a,R_B2a,R_B3a,B3b,G1,S9,S10,Q2a,Q2b,Q2c,B1,B2,B3,B4,B5,B6,B7,B8,A_B1a,A_B2a,A_B3a,B4a,C1,C2,C3,C4,C5,A1,A2,A3,G,RDINT1,BRDINT2,BRDINT3,IQSINT3,IQSINT2,IQSINT1,S11,S12,S13,sid,ATT,IMG,A4,C6,S3b,attimg1,attimg2,attimg3,mth
FROM car_data_bca;


--HBase_Hive  ->  HDFS_Hive（raws）
CREATE EXTERNAL TABLE raws(ROWKEY BINARY,D STRING,YR STRING,CX ARRAY<STRING>,GJ ARRAY<STRING>,JK ARRAY<STRING>,RY ARRAY<STRING>,B2a STRING,B3b STRING,A_S2 STRING,S3a STRING,A_S8a STRING,A_S8b STRING,A_S7 STRING,S3b STRING,S4 STRING,S5 STRING,S6 STRING,S9 STRING,S10 STRING,S11 STRING,S12 STRING,S13 STRING,R_S7 STRING,R_S2 STRING,R_S8a STRING,R_S8b STRING,Q1 STRING,S1 STRING)
PARTITIONED BY (mth STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
COLLECTION ITEMS TERMINATED BY ','
MAP KEYS TERMINATED BY ':'
STORED AS orc


--导入数据
INSERT OVERWRITE TABLE raws
PARTITION (mth)
SELECT ROWKEY,D,YR,CX,GJ,JK,RY,B2a,B3b,A_S2,S3a,A_S8a,A_S8b,A_S7,S3b,S4,S5,s6,S9,S10,S11,S12,S13,R_S7,R_S2,R_S8a,R_S8b,Q1,S1,mth
FROM car_data_raws;