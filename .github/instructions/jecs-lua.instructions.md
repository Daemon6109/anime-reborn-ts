Jecs
Jecs. Just an Entity Component System.

Properties
World

jecs.World: World
A world is a container of all ECS data. Games can have multiple worlds but component IDs may conflict between worlds. Ensure to register the same component IDs in the same order for each world.

Wildcard

jecs.Wildcard: Entity
Builtin component type. This ID is used for wildcard queries.

Component

jecs.Component: Entity
Builtin component type. Every ID created with world:component() has this type added to it. This is meant for querying every component ID.

ChildOf

jecs.ChildOf: Entity
Builtin component type. This ID is for creating parent-child hierarchies.

Rest

jecs.Rest: Entity
Functions
pair()

function jecs.pair(
first: Entity, -- The first element of the pair, referred to as the relationship of the relationship pair.
object: Entity, -- The second element of the pair, referred to as the target of the relationship pair.
): number -- Returns the ID with those two elements
INFO

While relationship pairs can be used as components and have data associated with an ID, they cannot be used as entities. Meaning you cannot add components to a pair as the source of a binding.

Pager

World
A World contains entities which have components. The World is queryable and can be used to get entities with a specific set of components and to perform different kinds of operations on them.

Functions
new
World utilizes a class, meaning JECS allows you to create multiple worlds.

function World.new(): World
Example:

luau

typescript

local world = jecs.World.new()
local myOtherWorld = jecs.World.new()
Methods
entity
Creates a new entity. It accepts the overload to create an entity with a specific ID.

function World:entity<T>(
id: Entity<T>? -- The desired id
): Entity<T>
Example:

luau

typescript

local entity = world:entity()
component
Creates a new component. Do note components are entities as well, meaning JECS allows you to add other components onto them.

These are meant to be added onto other entities through add and set

function World:component<T>(): Entity<T> -- The new componen.
Example:

luau

typescript

local Health = world:component() :: jecs.Entity<number> -- Typecasting this will allow us to know what kind of data the component holds!
get
Returns the data present in the component that was set in the entity. Will return nil if the component was a tag or is not present.

function World:get<T>(
entity: Entity, -- The entity
id: Entity<T> -- The component ID to fetch
): T?
Example:

luau

typescript

local Health = world:component() :: jecs.Entity<number>

local Entity = world:entity()
world:set(Entity, Health, 100)

print(world:get(Entity, Health))

-- Outputs:
-- 100
has
Returns whether an entity has a component (ID). Useful for checking if an entity has a tag or if you don't care of the data that is inside the component.

function World:has(
entity: Entity, -- The entity
id: Entity<T> -- The component ID to check
): boolean
Example:

luau

typescript

local IsMoving = world:component()
local Ragdolled = world:entity() -- This is a tag, meaning it won't contain data
local Health = world:component() :: jecs.Entity<number>

local Entity = world:entity()
world:set(Entity, Health, 100)
world:add(Entity, Ragdolled)

print(world:has(Entity, Health))
print(world:has(Entity, IsMoving)

print(world:get(Entity, Ragdolled))
print(world:has(Entity, Ragdolled))

-- Outputs:
-- true
-- false
-- nil
-- true
add
Adds a component (ID) to the entity. Useful for adding a tag to an entity, as this adds the component to the entity without any additional values inside

function World:add(
entity: Entity, -- The entity
id: Entity<T> -- The component ID to add
): void
INFO

This function is idempotent, meaning if the entity already has the id, this operation will have no side effects.

set
Adds or changes data in the entity's component.

function World:set(
entity: Entity, -- The entity
id: Entity<T>, -- The component ID to set
data: T -- The data of the component's type
): void
Example:

luau

typescript

local Health = world:component() :: jecs.Entity<number>

local Entity = world:entity()
world:set(Entity, Health, 100)

print(world:get(Entity, Health))

world:set(Entity, Health, 50)
print(world:get(Entity, Health))

-- Outputs:
-- 100
-- 50
query
Creates a query with the given components (IDs). Entities that satisfies the conditions of the query will be returned and their corresponding data.

function World:query(
...: Entity -- The components to query with
): Query
Example:

luau

typescript

-- Entity could also be a component if a component also meets the requirements, since they are also entities which you can add more components onto
for entity, position, velocity in world:query(Position, Velocity) do

end
INFO

Queries are uncached by default, this is generally very cheap unless you have high fragmentation from e.g. relationships.

target
Get the target of a relationship. This will return a target (second element of a pair) of the entity for the specified relationship. The index allows for iterating through the targets, if a single entity has multiple targets for the same relationship. If the index is larger than the total number of instances the entity has for the relationship or if there is no pair with the specified relationship on the entity, the operation will return nil.

function World:target(
entity: Entity, -- The entity
relation: Entity, -- The relationship between the entity and the target
nth: number, -- The index
): Entity? -- The target for the relationship at the specified index.
parent
Get parent (target of ChildOf relationship) for entity. If there is no ChildOf relationship pair, it will return nil.

function World:parent(
child: Entity -- The child ID to find the parent of
): Entity? -- Returns the parent of the child
This operation is the same as calling:

world:target(entity, jecs.ChildOf, 0)
contains
Checks if an entity or component (id) exists in the world.

function World:contains(
entity: Entity,
): boolean
Example:

luau

typescript

local entity = world:entity()
print(world:contains(entity))
print(world:contains(1))
print(world:contains(2))

-- Outputs:
-- true
-- true
-- false
remove
Removes a component (ID) from an entity

function World:remove(
entity: Entity,
component: Entity<T>
): void
Example:

luau

typescript

local IsMoving = world:component()

local entity = world:entity()
world:add(entity, IsMoving)

print(world:has(entity, IsMoving))

world:remove(entity, IsMoving)
print(world:has(entity, IsMoving))

-- Outputs:
-- true
-- false
delete
Deletes an entity and all of its related components and relationships.

function World:delete(
entity: Entity
): void
Example:

luau

typescript

local entity = world:entity()
print(world:has(entity))

world:delete(entity)

print(world:has(entity))

-- Outputs:
-- true
-- false
clear
Clears all of the components and relationships of the entity without deleting it.

function World:clear(
entity: Entity
): void
each
Iterate over all entities with the specified component. Useful when you only need the entity for a specific ID and you want to avoid creating a query.

function World:each(
id: Entity -- The component ID
): () -> Entity
Example:

luau

typescript

local id = world:entity()
for entity in world:each(id) do
-- Do something
end
children
Iterate entities in root of parent

function World:children(
parent: Entity -- The parent entity
): () -> Entity
This is the same as calling:

world:each(pair(ChildOf, parent))
range
Enforces a check for entities to be created within a desired range.

function World:range(
range_begin: number -- The starting point,
range_begin: number? -- The end point (optional)
)
Query
A World contains entities which have components. The World is queryable and can be used to get entities with a specific set of components.

Methods
iter
Returns an iterator that can be used to iterate over the query.

function Query:iter(): () -> (Entity, ...)
with
Adds components (IDs) to query with, but will not use their data. This is useful for Tags or generally just data you do not care for.

function Query:with(
...: Entity -- The IDs to query with
): Query
Example:

luau

typescript

for id, position in world:query(Position):with(Velocity) do
-- Do something
end
INFO

Put the IDs inside of world:query() instead if you need the data.

without
Removes entities with the provided components from the query.

function Query:without(
...: Entity -- The IDs to filter against.
): Query -- Returns the Query
Example:

luau

typescript

for entity, position in world:query(Position):without(Velocity) do
-- Do something
end
archetypes
Returns the matching archetypes of the query.

function Query:archetypes(): { Archetype }
Example:

for i, archetype in world:query(Position, Velocity):archetypes() do
local columns = archetype.columns
local field = archetype.records

    local P = field[Position]
    local V = field[Velocity]

    for row, entity in archetype.entities do
        local position = columns[P][row]
        local velocity = columns[V][row]
        -- Do something
    end

end
INFO

This function is meant for people who want to really customize their query behaviour at the archetype-level

cached
Returns a cached version of the query. This is useful if you want to iterate over the same query multiple times.

function Query:cached(): Query -- Returns the cached Query

Jecs
Jecs. Just an Entity Component System.

Properties
World

jecs.World: World
A world is a container of all ECS data. Games can have multiple worlds but component IDs may conflict between worlds. Ensure to register the same component IDs in the same order for each world.

Wildcard

jecs.Wildcard: Entity
Builtin component type. This ID is used for wildcard queries.

Component

jecs.Component: Entity
Builtin component type. Every ID created with world:component() has this type added to it. This is meant for querying every component ID.

ChildOf

jecs.ChildOf: Entity
Builtin component type. This ID is for creating parent-child hierarchies.

Rest

jecs.Rest: Entity
Functions
pair()

function jecs.pair(
first: Entity, -- The first element of the pair, referred to as the relationship of the relationship pair.
object: Entity, -- The second element of the pair, referred to as the target of the relationship pair.
): number -- Returns the ID with those two elements
INFO

While relationship pairs can be used as components and have data associated with an ID, they cannot be used as entities. Meaning you cannot add components to a pair as the source of a binding.

World
A World contains entities which have components. The World is queryable and can be used to get entities with a specific set of components and to perform different kinds of operations on them.

Functions
new
World utilizes a class, meaning JECS allows you to create multiple worlds.

function World.new(): World
Example:

luau

typescript

local world = jecs.World.new()
local myOtherWorld = jecs.World.new()
Methods
entity
Creates a new entity. It accepts the overload to create an entity with a specific ID.

function World:entity<T>(
id: Entity<T>? -- The desired id
): Entity<T>
Example:

luau

typescript

local entity = world:entity()
component
Creates a new component. Do note components are entities as well, meaning JECS allows you to add other components onto them.

These are meant to be added onto other entities through add and set

function World:component<T>(): Entity<T> -- The new componen.
Example:

luau

typescript

local Health = world:component() :: jecs.Entity<number> -- Typecasting this will allow us to know what kind of data the component holds!
get
Returns the data present in the component that was set in the entity. Will return nil if the component was a tag or is not present.

function World:get<T>(
entity: Entity, -- The entity
id: Entity<T> -- The component ID to fetch
): T?
Example:

luau

typescript

local Health = world:component() :: jecs.Entity<number>

local Entity = world:entity()
world:set(Entity, Health, 100)

print(world:get(Entity, Health))

-- Outputs:
-- 100
has
Returns whether an entity has a component (ID). Useful for checking if an entity has a tag or if you don't care of the data that is inside the component.

function World:has(
entity: Entity, -- The entity
id: Entity<T> -- The component ID to check
): boolean
Example:

luau

typescript

local IsMoving = world:component()
local Ragdolled = world:entity() -- This is a tag, meaning it won't contain data
local Health = world:component() :: jecs.Entity<number>

local Entity = world:entity()
world:set(Entity, Health, 100)
world:add(Entity, Ragdolled)

print(world:has(Entity, Health))
print(world:has(Entity, IsMoving)

print(world:get(Entity, Ragdolled))
print(world:has(Entity, Ragdolled))

-- Outputs:
-- true
-- false
-- nil
-- true
add
Adds a component (ID) to the entity. Useful for adding a tag to an entity, as this adds the component to the entity without any additional values inside

function World:add(
entity: Entity, -- The entity
id: Entity<T> -- The component ID to add
): void
INFO

This function is idempotent, meaning if the entity already has the id, this operation will have no side effects.

set
Adds or changes data in the entity's component.

function World:set(
entity: Entity, -- The entity
id: Entity<T>, -- The component ID to set
data: T -- The data of the component's type
): void
Example:

luau

typescript

local Health = world:component() :: jecs.Entity<number>

local Entity = world:entity()
world:set(Entity, Health, 100)

print(world:get(Entity, Health))

world:set(Entity, Health, 50)
print(world:get(Entity, Health))

-- Outputs:
-- 100
-- 50
query
Creates a query with the given components (IDs). Entities that satisfies the conditions of the query will be returned and their corresponding data.

function World:query(
...: Entity -- The components to query with
): Query
Example:

luau

typescript

-- Entity could also be a component if a component also meets the requirements, since they are also entities which you can add more components onto
for entity, position, velocity in world:query(Position, Velocity) do

end
INFO

Queries are uncached by default, this is generally very cheap unless you have high fragmentation from e.g. relationships.

target
Get the target of a relationship. This will return a target (second element of a pair) of the entity for the specified relationship. The index allows for iterating through the targets, if a single entity has multiple targets for the same relationship. If the index is larger than the total number of instances the entity has for the relationship or if there is no pair with the specified relationship on the entity, the operation will return nil.

function World:target(
entity: Entity, -- The entity
relation: Entity, -- The relationship between the entity and the target
nth: number, -- The index
): Entity? -- The target for the relationship at the specified index.
parent
Get parent (target of ChildOf relationship) for entity. If there is no ChildOf relationship pair, it will return nil.

function World:parent(
child: Entity -- The child ID to find the parent of
): Entity? -- Returns the parent of the child
This operation is the same as calling:

world:target(entity, jecs.ChildOf, 0)
contains
Checks if an entity or component (id) exists in the world.

function World:contains(
entity: Entity,
): boolean
Example:

luau

typescript

local entity = world:entity()
print(world:contains(entity))
print(world:contains(1))
print(world:contains(2))

-- Outputs:
-- true
-- true
-- false
remove
Removes a component (ID) from an entity

function World:remove(
entity: Entity,
component: Entity<T>
): void
Example:

luau

typescript

local IsMoving = world:component()

local entity = world:entity()
world:add(entity, IsMoving)

print(world:has(entity, IsMoving))

world:remove(entity, IsMoving)
print(world:has(entity, IsMoving))

-- Outputs:
-- true
-- false
delete
Deletes an entity and all of its related components and relationships.

function World:delete(
entity: Entity
): void
Example:

luau

typescript

local entity = world:entity()
print(world:has(entity))

world:delete(entity)

print(world:has(entity))

-- Outputs:
-- true
-- false
clear
Clears all of the components and relationships of the entity without deleting it.

function World:clear(
entity: Entity
): void
each
Iterate over all entities with the specified component. Useful when you only need the entity for a specific ID and you want to avoid creating a query.

function World:each(
id: Entity -- The component ID
): () -> Entity
Example:

luau

typescript

local id = world:entity()
for entity in world:each(id) do
-- Do something
end
children
Iterate entities in root of parent

function World:children(
parent: Entity -- The parent entity
): () -> Entity
This is the same as calling:

world:each(pair(ChildOf, parent))
range
Enforces a check for entities to be created within a desired range.

function World:range(
range_begin: number -- The starting point,
range_begin: number? -- The end point (optional)
)

Query
A World contains entities which have components. The World is queryable and can be used to get entities with a specific set of components.

Methods
iter
Returns an iterator that can be used to iterate over the query.

function Query:iter(): () -> (Entity, ...)
with
Adds components (IDs) to query with, but will not use their data. This is useful for Tags or generally just data you do not care for.

function Query:with(
...: Entity -- The IDs to query with
): Query
Example:

luau

typescript

for id, position in world:query(Position):with(Velocity) do
-- Do something
end
INFO

Put the IDs inside of world:query() instead if you need the data.

without
Removes entities with the provided components from the query.

function Query:without(
...: Entity -- The IDs to filter against.
): Query -- Returns the Query
Example:

luau

typescript

for entity, position in world:query(Position):without(Velocity) do
-- Do something
end
archetypes
Returns the matching archetypes of the query.

function Query:archetypes(): { Archetype }
Example:

for i, archetype in world:query(Position, Velocity):archetypes() do
local columns = archetype.columns
local field = archetype.records

    local P = field[Position]
    local V = field[Velocity]

    for row, entity in archetype.entities do
        local position = columns[P][row]
        local velocity = columns[V][row]
        -- Do something
    end

end
INFO

This function is meant for people who want to really customize their query behaviour at the archetype-level

cached
Returns a cached version of the query. This is useful if you want to iterate over the same query multiple times.

function Query:cached(): Query -- Returns the cached Query
