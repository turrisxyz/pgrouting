/* -- q1 */
SELECT * FROM pgr_stoerWagner(
    'SELECT id, source, target, cost, reverse_cost 
        FROM edge_table 
     WHERE id < 17'
);

/* -- q2 */
SELECT * FROM pgr_stoerWagner(
    'SELECT id, source, target, cost, reverse_cost 
        FROM edge_table 
     WHERE id = 18'
);

/* -- q3 */
SELECT * FROM pgr_stoerWagner(
$$
 SELECT id, source, target, cost, reverse_cost FROM edge_table 
    where source = any (ARRAY(SELECT node FROM pgr_connectedComponents(
                            'SELECT id, source, target, cost, reverse_cost FROM edge_table ')
                        WHERE component = 14)
                       ) 
                   OR     
          target = any (ARRAY(SELECT node FROM pgr_connectedComponents(
                            'SELECT id, source, target, cost, reverse_cost FROM edge_table ')
                        WHERE component = 14)
                       )
$$
 );

/* -- q4 */
