-- ============================================================
-- Seed Data for Development
-- ============================================================

-- ── Houses (Hogwarts Edition) ──
-- Truncate existing houses CASCADE to safely detach current students
TRUNCATE TABLE public.houses CASCADE;

INSERT INTO public.houses (id, name, color, icon, motto, total_points, member_count) VALUES
  ('gryffindor', 'Gryffindor', '#7F0909', 'local_fire_department', 'Courage, bravery, and determination', 0, 0),
  ('slytherin',  'Slytherin',  '#0D6217', 'water_drop',          'Ambition, cunning, and resourcefulness', 0, 0),
  ('ravenclaw',  'Ravenclaw',  '#0E1A40', 'air',                 'Intelligence, wisdom, and creativity', 0, 0),
  ('hufflepuff', 'Hufflepuff', '#EEB939', 'eco',                 'Hard work, patience, and loyalty', 0, 0);

-- ── Books (18 books matching mock data) ──
-- ── Books (Anna University Subjects) ──
-- Truncate existing books (and dependent tracking) to populate ONLY study books
TRUNCATE TABLE public.books CASCADE;

INSERT INTO public.books (id, title, author, isbn, genre, description, total_copies, available_copies, created_at) VALUES
  (gen_random_uuid(), 'Computer Architecture: A Quantitative Approach', 'John L. Hennessy', '9780128119051', 'Textbook', 'CS8491 Computer Architecture. Covers instruction sets, pipeline architectures, and memory hierarchies.', 10, 10, now()),
  (gen_random_uuid(), 'Database System Concepts', 'Abraham Silberschatz', '9780073523323', 'Textbook', 'CS8492 Database Management Systems. Relational algebra, SQL, normal forms, and transaction management.', 12, 12, now()),
  (gen_random_uuid(), 'Operating System Concepts', 'Abraham Silberschatz', '9781119800361', 'Textbook', 'CS8493 Operating Systems. Process management, scheduling, Deadlocks, memory management, and file systems.', 15, 15, now()),
  (gen_random_uuid(), 'Software Engineering: A Practitioner''s Approach', 'Roger S. Pressman', '9780078022128', 'Textbook', 'CS8494 Software Engineering. Agile development, life cycle models, testing, and quality assurance.', 8, 8, now()),
  (gen_random_uuid(), 'Probability, Statistics and Random Processes', 'T. Veerarajan', '9780072292228', 'Mathematics', 'MA8402 Probability and Queueing Theory. Random variables, Markov chains, and queueing models.', 20, 20, now()),
  (gen_random_uuid(), 'Introduction to Algorithms', 'Thomas H. Cormen', '9780262033848', 'Textbook', 'CS8451 Design and Analysis of Algorithms. NP completeness, dynamic programming, and greedy algorithms.', 10, 10, now()),
  (gen_random_uuid(), 'Digital Design', 'M. Morris Mano', '9780132774208', 'Textbook', 'CS8351 Digital Principles and System Design. Combinational logic, sequential circuits, and HDL.', 15, 15, now()),
  (gen_random_uuid(), 'Data Structures and Algorithm Analysis in C', 'Mark Allen Weiss', '9780201498400', 'Textbook', 'CS8391 Data Structures. Stacks, queues, linked lists, trees, graphs, and hashing techniques.', 25, 25, now()),
  (gen_random_uuid(), 'Object-Oriented Programming in C++', 'Robert Lafore', '9780672323089', 'Textbook', 'CS8392 Object Oriented Programming. Inheritance, polymorphism, virtual functions, and STL.', 18, 18, now()),
  (gen_random_uuid(), 'Principles of Communication Systems', 'Taub & Schilling', '9780070648111', 'Textbook', 'EC8395 Communication Engineering. AM, FM, digital modulation techniques, and spread spectrum.', 5, 5, now()),
  (gen_random_uuid(), 'Discrete Mathematics and Its Applications', 'Kenneth H. Rosen', '9780072899054', 'Mathematics', 'MA8351 Discrete Mathematics. Logic, set theory, combinatorics, and graph theory concepts.', 12, 12, now()),
  (gen_random_uuid(), 'Computer Networking: A Top-Down Approach', 'James F. Kurose', '9780133594140', 'Textbook', 'CS8591 Computer Networks. OSI model, TCP/IP protocol suite, routing algorithms, and network security.', 14, 14, now()),
  (gen_random_uuid(), 'Microprocessors and Interfacing', 'Douglas V. Hall', '9781259006159', 'Textbook', 'EC8691 Microprocessors and Microcontrollers. 8086 architectures, 8051 programming, and interfacing.', 8, 8, now()),
  (gen_random_uuid(), 'Introduction to Automata Theory', 'John E. Hopcroft', '9780201441246', 'Textbook', 'CS8501 Theory of Computation. Finite automata, pushdown automata, and Turing machines.', 6, 6, now()),
  (gen_random_uuid(), 'UML Distilled', 'Martin Fowler', '9780321193681', 'Textbook', 'CS8592 Object Oriented Analysis and Design. UML diagrams, design patterns, and case studies.', 10, 10, now()),
  (gen_random_uuid(), 'Programming the World Wide Web', 'Robert W. Sebesta', '9780132665810', 'Textbook', 'IT8501 Web Technology. HTML5, CSS3, JavaScript, PHP, XML, and web services.', 7, 7, now()),
  (gen_random_uuid(), 'Core Java Volume I--Fundamentals', 'Cay S. Horstmann', '9780135166307', 'Textbook', 'CS8651 Internet Programming. Servlets, JSP, JDBC, and enterprise applications architecture.', 12, 12, now()),
  (gen_random_uuid(), 'Artificial Intelligence: A Modern Approach', 'Stuart Russell', '9780136042594', 'Textbook', 'CS8691 Artificial Intelligence. Search strategies, knowledge representation, and expert systems.', 10, 10, now()),
  (gen_random_uuid(), 'Mobile Communications', 'Jochen Schiller', '9780321123817', 'Textbook', 'CS8601 Mobile Computing. Wireless transmission, MAC protocols, Mobile IP, and WAP.', 5, 5, now()),
  (gen_random_uuid(), 'Compilers: Principles, Techniques, and Tools', 'Alfred V. Aho', '9780321486813', 'Textbook', 'CS8602 Compiler Design. Lexical analysis, syntax analysis, optimization, and code generation.', 6, 6, now()),
  (gen_random_uuid(), 'Distributed Systems: Concepts and Design', 'George Coulouris', '9780132143011', 'Textbook', 'CS8603 Distributed Systems. IPC, distributed objects, file systems, and name services.', 4, 4, now()),
  (gen_random_uuid(), 'Health Informatics: Practical Guide', 'Robert E. Hoyt', '9781387200546', 'Textbook', 'CS8075 Health and Medical Informatics. EHR, standards, interoperability, and telemedicine.', 3, 3, now()),
  (gen_random_uuid(), 'Green Information Technology', 'Mohammad Dastbaz', '9780857095008', 'Textbook', 'CS8078 Green Computing. Energy efficiency, e-waste management, and green data centers.', 4, 4, now()),
  (gen_random_uuid(), 'Software Testing Techniques', 'Boris Beizer', '9780442206727', 'Textbook', 'IT8076 Software Testing. Path testing, data flow testing, and defect tracking metrics.', 7, 7, now()),
  (gen_random_uuid(), 'Cyber Forensics: A Field Manual', 'Albert Marcella Jr.', '9780849383281', 'Textbook', 'CS8074 Cyber Forensics. Digital evidence processing, network forensics, and legal issues.', 5, 5, now()),
  (gen_random_uuid(), 'Designing the User Interface', 'Ben Shneiderman', '9780134380386', 'Textbook', 'CS8079 Human Computer Interaction. UID concepts, cognitive models, and evaluation techniques.', 4, 4, now()),
  (gen_random_uuid(), 'Internet of Things: A Hands-On Approach', 'Arshdeep Bahga', '9780996025515', 'Textbook', 'CS8081 Internet of Things. IoT architecture, Python integration, Raspberry Pi, and Arduino.', 12, 12, now()),
  (gen_random_uuid(), 'Machine Learning', 'Tom M. Mitchell', '9780070428072', 'Textbook', 'CS8082 Machine Learning Techniques. Neural networks, Bayesian learning, and decision trees.', 8, 8, now()),
  (gen_random_uuid(), 'Big Data and Hadoop', 'V.K. Jain', '9789352718742', 'Textbook', 'CS8091 Big Data Analytics. MapReduce, Hadoop ecosystem, NoSQL, and stream analytics.', 10, 10, now()),
  (gen_random_uuid(), 'Computer Graphics C Version', 'Donald Hearn', '9780135309247', 'Textbook', 'CS8092 Computer Graphics and Multimedia. 2D/3D transformations, viewing pipelines, and animation.', 7, 7, now()),
  (gen_random_uuid(), 'Python Programming: An Introduction', 'John Zelle', '9781590282755', 'Textbook', 'GE8151 Problem Solving and Python Programming. Algorithmic thinking, data structures, and I/O.', 30, 30, now()),
  (gen_random_uuid(), 'Engineering Drawing', 'N.D. Bhatt', '9789380358178', 'Textbook', 'GE8152 Engineering Graphics. Orthographic projections, isometric views, and CAD basics.', 20, 20, now());
