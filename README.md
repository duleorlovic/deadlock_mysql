# Deadlock example

Inspired by https://vimeo.com/12941188

https://dev.mysql.com/doc/refman/8.0/en/innodb-locking.html

Innodb have two types or row-level locks:

* shared lock `S` permits to read a row
* exclusive lock `X` permits to update or delete a row

If T1 holds S lock on r, than T2 can be granted with S lock on r, but for X
lock, T2 needs to wait for T1 to release a S lock.
If T1 holds X lock than T2 have to wait for either type of lock it requests.

There are *Intention Locks* that tells which type of lock a transaction requires
later for a row in a table:

* intention shared lock `IS` wants shared lock on individual rows `SELECT ...
  FOR SHARE`
* intention exclusive lock `IX` wants exclusive lock on individual rows `SELECT
  ... FOR UPDATE`

When some transaction requires `IX` lock it prevents other from acquiring any
`S` or `X` lock on the table. When some requires `IS` on the table, than other
can not get `X` locks on the table.

*Record Locks* is lock on an index record `SELECT c1 FROM t WHERE c1=10 FOR
UPDATE` prevents other transactions iud (insert update delete) where the value
of `t.c1` is 10.

Full table lock `LOCK TABLES ... WRITE`.
To debug run:

~~~
mysql -u root -p deadlock_mysql_development
SHOW ENGINE INNODB STATUS
~~~

https://dev.mysql.com/doc/refman/8.0/en/innodb-deadlock-example.html
Deadlock example is when T1 requests holds `S` and T2 requests `X` and than T1
requests `X`.

# Run

To see examples run tests and watch rails logger

~~~
tail -f log/*
~~~
