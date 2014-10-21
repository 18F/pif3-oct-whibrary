module Search
  class Table
    class << self
      def create!
        DB.execute_ddl <<-SQL
          create table docs (
            id serial primary key,
            name varchar not null,
            content text not null,
            terms tsvector not null
          );

          create or replace function docs_terms_tfun() returns trigger as $$
            begin
              new.terms := to_tsvector('pg_catalog.english', coalesce(new.content, ''));

              return new;
            end;
          $$ language 'plpgsql';

          create trigger docs_terms_trig
          before insert or update
          of content, terms
          on docs for each row
          execute procedure docs_terms_tfun();
        SQL
      end

      def load!
        Dir['./docs/*.txt'].each do |name|
          path = Pathname(name)

          DB[:docs].insert({
            name: name,
            content: path.read
          })
        end
      end
    end
  end
end