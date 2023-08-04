using Glob

abstract type AbstractBlock end


struct H1 <: AbstractBlock
    content::String
end


struct CodeBlock <: AbstractBlock
    title::String
    sample_in::String
    sample_out::String
    in_file::Vector{String}
    out_file::Vector{String}
    function CodeBlock(title, in_sample, out_sample, in_files, out_files)
        in_files = glob(in_files)
        out_files = glob(out_files)
        return new(title, in_sample, out_sample, in_files, out_files)
    end
end


struct PlainText <: AbstractBlock
    content :: String
end


struct MathBlock <: AbstractBlock
    content :: String
end

struct InLineMathBlock <: AbstractBlock
    content :: String
end

function render(block::H1)
    return "<h1> $(block.content) </h1>"
end


function render(block::CodeBlock)
    title = "<h2 class=\"problem_title\"> <div class=\'badge\' id=\'$(objectid(block))_status\'>WJ</div>  $(block.title) </h2> \n"
    
    editor_div = "<div class=\"editor\" id=\"$(objectid(block))\" rows=\"3\" cols=\"80\"></div> \n"
    ace_editor = """
    <script> 
    
    editor = ace.edit(\"$(objectid(block))\"); 
    editor.setTheme("ace/theme/monokai");
    editor.session.setMode("ace/mode/python");
    editor.setShowPrintMargin(false);
    editor.setOptions({
      enableBasicAutocompletion: true,
      enableSnippets: true,
      enableLiveAutocompletion: true
    });
    editor.setValue("");
    
    </script>
    
    
    """    
    sample_in = join(readlines(block.sample_in), "\n")
    sample_out = join(readlines(block.sample_out), "\n")

    sample_in_area = "サンプルの入力: <pre class=\"sample_in\" id=\"$(objectid(block))_sample_in\"><code>$(sample_in)</code></pre> \n"
    sample_out_area = "出力: <pre class=\"sample_out\" id=\"$(objectid(block))_sample_out\"><code></code></pre> \n"
    expect_out_area = "サンプルの答え: <pre class=\"expect_out\" id=\"$(objectid(block))_expect_out\"><code>$(sample_out)</code></pre> \n"
    

    define_data = """
    <script>
    all_input[\"$(objectid(block))\"] = []
    all_output[\"$(objectid(block))\"] = []
    all_sample_input[\"$(objectid(block))\"] = \`$(sample_in)\`
    all_sample_output[\"$(objectid(block))\"] = \`$(sample_out)\`
    """

    for in_file in block.in_file
        define_data *= """
        all_input[\"$(objectid(block))\"].push(\"$(join(readlines(in_file), "\\n"))\")
        """
    end

    for out_file in block.out_file
        define_data *= """
        all_output[\"$(objectid(block))\"].push(\"$(join(readlines(out_file), "\\n"))\")
        """
    end

    define_data *= "</script> \n"


    test_run_button = "<button class=\"runbutton\" onclick=\"runCode(\'$(objectid(block))\', false)\"> Run Sample </button> \n"
    submit_button = "<button class=\"submitbutton\" onclick=\"runCode(\'$(objectid(block))\', true)\"> Submit </button> \n"

    return join(
        [
            title,
            editor_div,
            ace_editor,
            sample_in_area,
            sample_out_area,
            expect_out_area,
            define_data,
            test_run_button,
            submit_button
        ]
    )
end


function render(block::PlainText)
    return block.content
end


function render(block::MathBlock)
    return """\\[
        $(block.content)
        \\]"""
end
    
function render(block::InLineMathBlock)
    return """\\($(block.content)\\)"""
end


function parse(S)
    result = AbstractBlock[]
    while !(isempty(S))
        s = popfirst!(S)
        if startswith(s, "#")
            push!(result, H1(s[2:end]))
        elseif startswith(s, ":::code")
            block = true
            title = nothing
            in_file = nothing
            out_file = nothing
            sample_in = nothing
            sample_out = nothing
            while block
                s = popfirst!(S)
                if startswith(s, "title=")
                    title = s[7:end]
                elseif startswith(s, "sample_in=")
                    sample_in = s[11:end]
                elseif startswith(s, "sample_out=")
                    sample_out = s[12:end]
                elseif startswith(s, "in=")
                    in_file = s[4:end]
                elseif startswith(s, "out=")
                    out_file = s[5:end]
                elseif startswith(s, ":::")
                    push!(result, CodeBlock(title, sample_in, sample_out, in_file, out_file))
                    block = false
                end
            end
        elseif startswith(s, "\$\$")
            block = true
            math = ""
            while block
                s = popfirst!(S)
                if startswith(s, "\$\$")
                    push!(result, MathBlock(math))
                    block = false
                else
                    math *= s 
                end
            end
        else
            if s == ""
                push!(result, PlainText("<br>"))
            else
                push!(result, PlainText(s))
            end
        end
    end
    return result
end



function load_template(;filename="template.html")
    template = readlines(filename)
    split_idx = findfirst((x -> occursin("<!-- ___split___ -->", x)), template)
    return template[begin:split_idx-1], template[split_idx+1:end]
end



function render(result::AbstractArray{<:AbstractBlock})
    TEMPLATE_HEAD, TEMPLATE_TAIL = load_template()
    println.(TEMPLATE_HEAD)
    for r in result
        println(render(r))
    end
    println.(TEMPLATE_TAIL)
end




function main()
    S = readlines("main.md")
    result = parse(S)
    render(result)
end


main()