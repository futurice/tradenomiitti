
exports.up = function(knex, Promise) {
  return knex.schema.table('contacts', function(table) {
    table.increments('id');
  });
};

exports.down = function(knex, Promise) {
  return knex.schema.table('contacts', function(table) {
    table.dropColumn('id');
  });
};
