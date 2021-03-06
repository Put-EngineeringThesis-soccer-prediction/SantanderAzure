-- 'This query retrieves the 10 unshipped orders with the highest value.'

SELECT TOP 10 L_ORDERKEY, SUM(L_EXTENDEDPRICE*(1-L_DISCOUNT)) AS REVENUE, O_ORDERDATE, O_SHIPPRIORITY
FROM CUSTOMER
JOIN ORDERS ON C_CUSTKEY = O_CUSTKEY
JOIN LINEITEM ON L_ORDERKEY = O_ORDERKEY
WHERE C_MKTSEGMENT = 'BUILDING' AND O_ORDERDATE < '1995-03-15' AND L_SHIPDATE > '1995-03-15'
GROUP BY L_ORDERKEY, O_ORDERDATE, O_SHIPPRIORITY
ORDER BY REVENUE DESC, O_ORDERDATE;