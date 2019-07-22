\i setup.sql

SELECT plan(57);

SELECT has_function('pgr_contraction');

SELECT has_function('pgr_contraction', ARRAY[
    'text', 'bigint[]',
    'integer', 'bigint[]', 'boolean'
    ]);

SELECT function_returns('pgr_contraction', ARRAY[
    'text', 'bigint[]',
    'integer', 'bigint[]', 'boolean'
    ], 'setof record');

SELECT style_dijkstra('pgr_contraction', ', ARRAY[2]::BIGINT[], 1, ARRAY[3]::BIGINT[], true)');


SELECT finish();
ROLLBACK;
