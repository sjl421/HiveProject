--品牌总体评价-日线
WITH wtmp AS (
    SELECT rowkey,
           to_date(s6) AS time,
           cx
    FROM raws
    WHERE (s3a=="1" OR s9!="1")
          AND mth BETWEEN ${hivevar:lastmth}
          AND ${hivevar:lasttime}
          AND to_date(s6) BETWEEN ${hivevar:lasttime}
          AND ${hivevar:thistime}),
fm_tmp AS(  --fm评论数
    SELECT cg,
           cbrdint3,
           g1,
           fm,
           time AS s6
    FROM
        (SELECT sid,
                concat(cbrdint3,g1) AS cg,
                cbrdint3,
                g1,
                fm
        FROM bca LATERAL VIEW explode(brdint3) tbrdint3 AS cbrdint3
        WHERE mth BETWEEN 195 AND 196
              AND size(attimg2)>=1
              AND (s3a==1 OR s9!=1)
              AND  cbrdint3 IS NOT NULL) t1
    JOIN wtmp
      ON substr(wtmp.rowkey,0,16)=t1.sid
),
fm1_tmp AS(  --FM1评论数
     SELECT s6,
            concat(cbrdint3,g1) AS cg,
            cbrdint3,count(1) AS fm
     FROM fm_tmp
     WHERE fm=1
     GROUP BY s6,
              cbrdint3,
              g1
),
fm2_tmp AS(  ----FM2评论数
     SELECT s6,
            concat(cbrdint3,g1) AS cg,
            cbrdint3,
            g1,
            count(1) AS fm
     FROM fm_tmp
     WHERE fm=2
     GROUP BY s6,
              cbrdint3,
              g1
)
SELECT fm2_cot/t1.fm_g1 AS per,
       t.cbrdint3 AS model,
       t1.fm_g1 AS g1_cot,
       s6 AS time
FROM
--好评人数
    (SELECT fm2_tmp.cbrdint3,
            concat(fm2_tmp.cbrdint3,
            fm2_tmp.s6) AS mt,
            COUNT(fm2_tmp.g1) AS fm2_cot  --fm2人数
    FROM fm2_tmp
    LEFT JOIN fm1_tmp
           ON fm1_tmp.cg=fm2_tmp.cg
    WHERE fm2_tmp.fm>fm1_tmp.fm
             OR fm1_tmp.fm IS NULL
    GROUP BY fm2_tmp.cbrdint3,fm2_tmp.s6) t
JOIN
    (SELECT concat(cbrdint3,s6) AS mt,
            s6,COUNT(DISTINCT fm_tmp.g1) AS fm_g1 --车系对应的人数
FROM fm_tmp
GROUP BY cbrdint3,s6) t1
  ON t.mt=t1.mt