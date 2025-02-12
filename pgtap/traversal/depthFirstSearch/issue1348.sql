BEGIN;

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN min_version('3.2.0') THEN plan (8) ELSE plan(1) END;

CREATE OR REPLACE FUNCTION issue()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

IF NOT min_version('3.2.0') THEN
  RETURN QUERY
  SELECT skip(1, 'Function is new on 3.2.0');
  RETURN;
END IF;


CREATE TABLE sample_table (
    id BIGSERIAL,
    source BIGINT,
    target BIGINT,
    cost FLOAT,
    reverse_cost FLOAT
);

INSERT INTO sample_table (source, target, cost, reverse_cost) VALUES
    (3, 6, 20, 15),
    (3, 8, 10, -10),
    (6, 8, -1, 12);

PREPARE q0 AS
SELECT id, source, target, cost, reverse_cost FROM sample_table
ORDER BY id;


-- Query 1 (Directed)

PREPARE q1 AS
SELECT * FROM pgr_depthFirstSearch (
    'q0',
    3
);

RETURN QUERY
SELECT set_eq('q1',
    $$VALUES
        (1, 0, 3, 3, -1, 0, 0),
        (2, 1, 3, 6, 1, 20, 20),
        (3, 1, 3, 8, 2, 10, 10)
    $$,
    'q1: Directed Graph with Root vid 3'
);


-- Query 2 (Directed)

PREPARE q2 AS
SELECT * FROM pgr_depthFirstSearch (
    'q0',
    6
);

RETURN QUERY
SELECT set_eq('q2',
    $$VALUES
        (1, 0, 6, 6, -1, 0, 0),
        (2, 1, 6, 3, 1, 15, 15),
        (3, 2, 6, 8, 2, 10, 25)
    $$,
    'q2: Directed Graph with Root vid 6'
);


-- Query 3 (Directed with max_depth)

PREPARE q3 AS
SELECT * FROM pgr_depthFirstSearch (
    'q0',
    6, max_depth => 1
);

RETURN QUERY
SELECT set_eq('q3',
    $$VALUES
        (1, 0, 6, 6, -1, 0, 0),
        (2, 1, 6, 3, 1, 15, 15)
    $$,
    'q3: Directed Graph with Root vid 6 and max_depth 1'
);


-- Query 4 (Vertex does not exist)

PREPARE q4 AS
SELECT * FROM pgr_depthFirstSearch (
    'q0',
    2
);

RETURN QUERY
SELECT set_eq('q4',
    $$VALUES (1, 0, 2, 2, -1, 0, 0)$$,
    '4: Vertex not present in graph'
);


-- Query 5 (Undirected)

PREPARE q5 AS
SELECT * FROM pgr_depthFirstSearch (
    'q0',
    3, directed => false
);

RETURN QUERY
SELECT set_eq('q5',
    $$VALUES
        (1, 0, 3, 3, -1, 0, 0),
        (2, 1, 3, 6, 1, 20, 20),
        (3, 2, 3, 8, 3, 12, 32)
    $$,
    'q5: Undirected Graph with Root vid 3'
);


-- Query 6 (Undirected)

PREPARE q6 AS
SELECT * FROM pgr_depthFirstSearch (
    'q0',
    6, directed => false
);

RETURN QUERY
SELECT set_eq('q6',
    $$VALUES
        (1, 0, 6, 6, -1, 0, 0),
        (2, 1, 6, 3, 1, 20, 20),
        (3, 2, 6, 8, 2, 10, 30)
    $$,
    'q6: Undirected Graph with Root vid 6'
);


-- Query 7 (Undirected with max_depth)

PREPARE q7 AS
SELECT * FROM pgr_depthFirstSearch (
    'q0',
    6, directed => false, max_depth => 1
);

RETURN QUERY
SELECT set_eq('q7',
    $$VALUES
        (1, 0, 6, 6, -1, 0, 0),
        (2, 1, 6, 3, 1, 20, 20),
        (3, 1, 6, 8, 3, 12, 12)
    $$,
    'q7: Undirected Graph with Root vid 6 and max_depth 1'
);


-- Query 8 (Multiple Vertices)

PREPARE q8 AS
SELECT * FROM pgr_depthFirstSearch (
    'q0',
    ARRAY[6, 3, 6]
);

RETURN QUERY
SELECT set_eq('q8',
    $$VALUES
        (1, 0, 3, 3, -1, 0, 0),
        (2, 1, 3, 6, 1, 20, 20),
        (3, 1, 3, 8, 2, 10, 10),
        (4, 0, 6, 6, -1, 0, 0),
        (5, 1, 6, 3, 1, 15, 15),
        (6, 2, 6, 8, 2, 10, 25)
    $$,
    'q8: Directed Graph with multiple Root vids'
);

END;
$BODY$
LANGUAGE plpgsql;

SELECT issue();


SELECT * FROM finish();
ROLLBACK;
