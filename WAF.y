class WAFParser
rule
	syntax: request_method request action_logics
	{
		result = { "#{val[0].upcase} #{val[1]}" => val[2] }
	}

	request_method: REQ_MET

  request: REQ

  action_logics: LOG
end

---- header

---- inner

def parse(str)
	@q = []
	registered_action = {}
	remove_comment(str)

	until str.empty?
		case str
		when /^(get|post|delete|head) (\/.*)$((?:\n[\s&&[^\n]]+.+)+)$/
			@q.push [:REQ_MET, $1]
			@q.push [:REQ, $2]
			@q.push [:LOG, $3]
		when /^$/
      break
		end

		str = $'
    @q.push [false, '$end']
    registered_action.merge!(do_parse)
	end

  registered_action
end

def next_token
	@q.shift
end

def remove_comment(str)
	str.gsub!(/\s*#.*$/, '')
end

---- footer

require 'rack'
require 'haml'

parser = WAFParser.new

File.open("app.waf") do |f|
	$result = parser.parse(f.read)
end

class Application
	def self.call(env)
		request = Rack::Request.new(env)
		block = $result["#{request.request_method} #{request.path_info}"]
		body = nil

		case block
		when /^\s+haml :([^\s]+)/
			File.open("views/#{$1}.haml") do |t|
				body = Haml::Engine.new(t.read).render
			end
		else
			action_logics = "params = #{request.params};" + block.to_s
			body = eval(action_logics)
		end

		Rack::Response.new do |r|
			r.status = 200
			r['Content-Type'] = 'text/html;charset=utf8'
			r.write body
		end.finish
	end
end
