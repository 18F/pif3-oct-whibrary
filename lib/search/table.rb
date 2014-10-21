module Search
  class Table
    class << self
      def create!
        DB.execute_ddl <<-SQL
          create table docs (
            id serial primary key,
            name varchar not null,
            doctype varchar,
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
        doctypes = {}
          CSV.foreach("./metadata/doctypes.txt", :headers => false, :converters => :all) do |(filename, type)|
          doctypes[filename] = type
        end

        Dir['./docs/*.txt'].each do |name|
          path = Pathname(name)

          good_name = Pathname(name).basename.to_s

          DB[:docs].insert({
            name: name,
            doctype: doctypes[good_name],
            content: path.read
          })
        end
      end
    end
  end
end
