using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management.Automation.Language
using namespace PSMemo.Completers;

class MemoCompletionsAttribute : ArgumentCompleterAttribute, IArgumentCompleterFactory {
    [string] $Key;
    [ScriptBlock] $KeyResolver;

    MemoCompletionsAttribute([string] $key) {
        $this.Key = $key
    }

    MemoCompletionsAttribute([ScriptBlock] $keyResolver) {
        $this.KeyResolver = $keyResolver
    }

    [IArgumentCompleter] Create() {
        if ($this.KeyResolver) {
            return [MemoCompleter]::new($this.KeyResolver)
        }

        return [MemoCompleter]::new($this.Key)
    }
}

class EnumCompleter : IArgumentCompleter {

}

class EnumCompletionsAttribute : ArgumentCompleterAttribute, IArgumentCompleterFactory {


    NumberCompletionsAttribute([string[]] $values) {
        $this.Values = $values
    }

    [IArgumentCompleter] Create() { return [EnumCompleter]::new($this.Values) }
}


class NumberCompleter : IArgumentCompleter {

    [int] $From
    [int] $To
    [int] $Step

    NumberCompleter([int] $from, [int] $to, [int] $step) {
        if ($from -gt $to) {
            throw [ArgumentOutOfRangeException]::new('from')
        }
        $this.From = $from
        $this.To = $to
        $this.Step = $step -lt 1 ? 1 : $step
    }

    [IEnumerable[CompletionResult]] CompleteArgument(
        [string] $CommandName,
        [string] $parameterName,
        [string] $wordToComplete,
        [CommandAst] $commandAst,
        [IDictionary] $fakeBoundParameters) {

        $resultList = [List[CompletionResult]]::new()
        $local:to = $this.To
        $local:step = $this.Step
        for ($i = $this.From; $i -lt $to; $i += $step) {
            $resultList.Add([CompletionResult]::new($i.ToString()))
        }

        return $resultList
    }
}

class NumberCompletionsAttribute : ArgumentCompleterAttribute, IArgumentCompleterFactory {
    [int] $From
    [int] $To
    [int] $Step

    NumberCompletionsAttribute([int] $from, [int] $to, [int] $step) {
        $this.From = $from
        $this.To = $to
        $this.Step = $step
    }

    [IArgumentCompleter] Create() { return [NumberCompleter]::new($this.From, $this.To, $this.Step) }
}
