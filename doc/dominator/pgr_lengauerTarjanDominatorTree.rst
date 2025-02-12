..
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

|

* **Supported versions:**
  `Latest <https://docs.pgrouting.org/latest/en/pgr_lengauerTarjanDominatorTree.html>`__
  (`3.3 <https://docs.pgrouting.org/3.3/en/pgr_lengauerTarjanDominatorTree.html>`__)
  `3.2 <https://docs.pgrouting.org/3.2/en/pgr_lengauerTarjanDominatorTree.html>`__

pgr_lengauerTarjanDominatorTree -Experimental
===============================================================================

``pgr_lengauerTarjanDominatorTree`` — Returns the immediate dominator of all vertices.

.. figure:: images/boost-inside.jpeg
   :target: https://www.boost.org/libs/graph/doc/lengauer_tarjan_dominator.htm

   Boost Graph Inside

.. include:: experimental.rst
   :start-after: begin-warn-expr
   :end-before: end-warn-expr

.. rubric:: Availability

* Version 3.2.0

  * New **experimental** function


Description
-------------------------------------------------------------------------------
The algorithm calculates the *immidiate dominator* of each vertex called **idom**, once **idom** of each vertex is calculated then by making every **idom** of each vertex as its parent, the dominator tree can be built.

**The main Characteristics are:**

- The algorithm works in directed graph only.
- The returned values are not ordered.
- The algorithm returns *idom* of each vertex.
- If the *root vertex* not present in the graph then it returns empty set.
- Running time: :math:`O((V+E)log(V+E))`

Signatures
-------------------------------------------------------------------------------

.. rubric:: Summary

.. code-block:: sql

    pgr_lengauerTarjanDominatorTree(Edges SQL, root vertex)
    RETURNS SET OF (seq, vertex_id, idom)
    OR EMPTY SET


.. index::
    single: lengauerTarjanDominatorTree - Experimental on v3.2


:Example: The lengauerTarjanDominatorTree with root vertex :math:`1`

.. literalinclude:: doc-lengauerTarjanDominatorTree.queries
   :start-after: --q1
   :end-before: --q2

Parameters
-------------------------------------------------------------------------------

=============== ============ =================================================
Column          Type           Description
=============== ============ =================================================
**Edges SQL**    ``TEXT``    SQL query as described above.
**root vertex**  ``BIGINT``  Identifier of the starting vertex.
=============== ============ =================================================


Inner query
-------------------------------------------------------------------------------

.. include:: pgRouting-concepts.rst
    :start-after: basic_edges_sql_start
    :end-before: basic_edges_sql_end

Result Columns
-------------------------------------------------------------------------------

Returns set of ``(seq, vertex_id,idom)``

============== =========== =================================================
Column         Type        Description
============== =========== =================================================
**seq**        ``INTEGER`` Sequential value starting from **1**.
**vertex_id**  ``BIGINT``  Identifier of vertex .
**idom**       ``BIGINT``  Immediate dominator of vertex.
============== =========== =================================================

Additional Examples
------------------------------------------------------------------------------------------
The examples in this section use the following :ref:`fig1`

:Example: When the edge is disonnectd from graph then it will returns immidiate dominator of all other vertex as zero.



.. literalinclude:: doc-lengauerTarjanDominatorTree.queries
    :start-after: --q2
    :end-before: --q3

See Also
-------------------------------------------------------------------------------

* `Boost: lengauerTarjanDominatorTree algorithm documentation <https://www.boost.org/libs/graph/doc/lengauer_tarjan_dominator.htm>`__
* `Wikipedia: dominator tree <https://en.wikipedia.org/wiki/Dominator_(graph_theory)>`__
* :doc:`sampledata` network.

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
